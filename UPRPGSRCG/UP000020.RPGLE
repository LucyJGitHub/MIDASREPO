     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*XBI *  OVRDBF FILE(UPSFMTQT) TOFILE(UPSFMTPD)                       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Remove V_ type records from UPSFMTPD')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000019 - Work out priorities for SQL views                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK021  *CREATE    Date 22Sep04               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK021 - New utility to work out priorities for SQL views.   *
      *                                                               *
      *****************************************************************
      *
     FUPDBR1L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
     FUPDBR2L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     PREFIX(X)
      *
     FUPSFMTQT  UF A E             DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *
      * Array containing File and Dependent File
     D DSPDBR          S             20    DIM(999)
      *
      * Data structure for DSPDBR array.
     D                 DS
     D  DSPDBRArray            1     20
     D  ArrayWHRFI             1     10
     D  ArrayWHREFI           11     20
      *
      * Look up data structure.
     D                 DS
     D  DSPDBRLookUp           1     20
     D  LookUpWHRFI            1     10
     D  LookUpWHREFI          11     20
      *
     D/COPY GPCPYSRCG,PSDS
      *
     D CPYF_Cmd        S             60    INZ('CPYF FROMFILE(UPDBR1PD) +
     D                                     TOFILE(UPDBR2PD) MBROPT(*REPLACE)')
     D CPYF_CmdLen     S             15  5 INZ(60)
     D SavedWHRFI      S             10
     D SavedWHREFI     S             10
     D SavedXWHREFI    S             10
     D PLayer          S              7
     D Priority        S              1  0 INZ(0)
     D NoMoreDeps      S              1
     D NotEqual        S              1
     D Index           S              3  0
      *
     C/TITLE
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
      *
      * Execute subroutine to remove duplicate records.
     C                   EXSR      RemoveDups
      *
      * Loop through the DSPDBR outfile until there are no more dependencies to process.
     C                   DOU       NoMoreDeps = 'Y'
      *
     C                   EVAL      Index = 1
      *
      * Read file for dependent file.
     C                   OPEN      UPDBR2L0
     C     *LOVAL        SETLL     UPDBR2L0
     C                   READ      UPDBR2L0
     C                   DOW       NOT %EOF
      * Update DSPDBR array.
     C                   IF        XWHREFI <> SavedXWHREFI
     C                   EXSR      UpdateArray
     C                   ENDIF
     C                   EVAL      SavedXWHREFI = XWHREFI
     C                   READ      UPDBR2L0
     C                   ENDDO
     C                   CLOSE     UPDBR2L0
      *
      * Read through file to check against array; update UPSFMTQT and remove records
      *  from UPDBR1PD.
     C                   EXSR      UpdateUPSFMT
      *
     C                   EVAL      Priority = Priority + 1
     C                   EVAL      DSPDBR  = *blanks
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  RemoveDups - Remove duplicate records from UPDBR1PD          *
      *                                                               *
      *  Called By: *main                                             *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     RemoveDups    BEGSR
      *
     C                   OPEN      UPDBR1L0
     C     *LOVAL        SETLL     UPDBR1L0
     C                   READ      UPDBR1L0
     C                   DOW       NOT %EOF
     C                   IF        WHRFI = SavedWHRFI and
     C                             WHREFI = SavedWHREFI
     C                   DELETE    @DBR1L0
     C                   ELSE
     C                   EVAL      SavedWHRFI = WHRFI
     C                   EVAL      SavedWHREFI = WHREFI
     C                   ENDIF
     C                   READ      UPDBR1L0
     C                   ENDDO
      *
     C                   CLOSE     UPDBR1L0
      *
      * Copy changed version of UPDBR1PD to UPDBR2PD.
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    CPYF_Cmd
     C                   PARM                    CPYF_CmdLen
      *
     C     RemoveDupsE   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  CheckDBR - Check for database relations                      *
      *                                                               *
      *  Called By: *main                                             *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     UpdateArray   BEGSR
      *
     C                   OPEN      UPDBR1L0
      * Chain to UPDBROL0 to see if the dependent view also has dependencies.
     C     XWHREFI       CHAIN     UPDBR1L0
     C                   IF        NOT %FOUND
     C                   EVAL      NotEqual = 'Y'
     C                   ENDIF
      *
      * Continue reading while key is equal.
     C                   DOW       NotEqual <> 'Y' and
     C                             NOT %EOF
      * Write record to array.
     C                   EVAL      ArrayWHRFI = WHRFI
     C                   EVAL      ArrayWHREFI = WHREFI
     C                   EVAL      DSPDBR(Index) = DSPDBRArray
     C                   EVAL      Index = Index + 1
      *
     C                   READ      UPDBR1L0
     C                   IF        WHRFI <> XWHREFI
     C                   EVAL      NotEqual = 'Y'
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      NotEqual = 'N'
     C                   CLOSE     UPDBR1L0
      *
     C     UpdateArrayE  ENDSR
      *
      *****************************************************************
      *                                                               *
      *  UpdateUPSMT - Update UPSFMTQF and remove records from        *
      *                UPDBROPD, depending on array.                  *
      *                                                               *
      *  Called By: *main                                             *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     UpdateUPSFMT  BEGSR
      *
      * Read UPDBROL0 and see if combination of WHRFI and WHREFI exists on
      * array.  If it doesn't then write to UPSFMTQT and delete record from
      * UPDBROPD.
     C                   OPEN      UPDBR1L0
     C     *LOVAL        SETLL     UPDBR1L0
     C                   READ      UPDBR1L0
      * If the file is empty then end set on the flag to end the program.
     C                   IF        %EOF
     C                   EVAL      NoMoreDeps = 'Y'
     C                   ENDIF
     C                   DOW       NOT %EOF
     C                   EVAL      LookUpWHRFI = WHRFI
     C                   EVAL      LookUpWHREFI = WHREFI
     C     DSPDBRLookUp  LOOKUP    DSPDBR                                 69
      * If not found on array then write record to UPSFMTQT ...
     C                   IF        *IN69 = *OFF
     C                   EVAL      FSFILE = WHREFI
     C                   EVAL      FSFSHD = WHRFI
     C                   EVAL      FSTYPE = 'V'
     C                   EVAL      FSSFMT = '*NONE'
     C                   EVAL      FSIPTY = Priority
     C                   EVAL      FSLAYR = PLayer
     C                   WRITE     UPSFMTD1
      * ... and delete record from UPDBR1PD.
     C                   DELETE    @DBR1L0
     C                   EVAL      *IN69 = *OFF
     C                   ENDIF
      *
     C                   READ      UPDBR1L0
      *
     C                   ENDDO
      *
     C                   CLOSE     UPDBR1L0
      *
      * Copy changed version of UPDBR1PD to UPDBR2PD.
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    CPYF_Cmd
     C                   PARM                    CPYF_CmdLen
     C                   IF        *IN50 = *ON
     C     PSExcpNo      IFEQ      '2817'
     C                   EVAL      *IN50 = *OFF
     C                   ELSE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C     UpdateUPSFMTE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: *ALL                                               *
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
      *
      ********************************************************************
