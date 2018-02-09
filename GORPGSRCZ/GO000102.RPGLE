     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Download data control - CoB')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000102 - Global Processing data dowload, CoB               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD020167           Date 23Apr13               *
      *                 AR1096739          Date 20Mar13               *
      *                 CCB023             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9512            Date 05Dec05               *
      *                 CGP002  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  AR1096739 - Secondary COB dashboard issues                   *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring (Recompile)                           *
      *  BUG9512 - Signal errors to calling program in U7U8.          *
      *  CGP002 - Global Processing data download                     *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                            BUG9512
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      * External data structure for CoB status details
     DCoBStatus      E DS                  EXTNAME(CBSTAT)
      *
      * External data structure for CoB run details
     DCoBRun         E DS                  EXTNAME(CBRUN)
      *
     D                 DS
     D  CoBRunData             1      6
     D  TotalCmps              1      3P 0
     D  AlreadyRun             4      6P 0
      *
     D                 DS
     D  TotalN                 1      5  0
     D  TotalA                 1      5
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
      *
     D @RUN            S              1
     D Value           S             50
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C/COPY GOCPYSRC,GOUPD_PARM
      *
     C     *DTAARA       DEFINE    CBRUN         CoBRun
     C     *DTAARA       DEFINE    CBSTAT        CoBStatus
      *
      * CoB Components Left to Run
     C                   IF        Key_Desc = 'CoBCmpsLeftToRun'
      * Retrieve data.
     C                   IN        CoBRun
     C                   EVAL      CoBRunData = CoBRun
      *
      * If the Midas phase is not CoB then set data to blank.
     C                   IF        MidasPhase <> 'C'
     C                             AND                                                     AR1096739
     C                             MidasPhase <> 'G'                                       AR1096739
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   IF        CoBRunData <> *blanks
     C                   EVAL      TotalN = TotalCmps - AlreadyRun
     C                   EVAL      Value = TotalA
     C                   ELSE
     C                   EVAL      Value = *blanks
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * CoB Components Already Run
     C                   IF        Key_Desc = 'CoBCmpsAlreadyRun'
      * Retrieve data.
     C                   IN        CoBRun
     C                   EVAL      CoBRunData = CoBRun
      *
      * If the Midas phase is not CoB then set data to blank.
     C                   IF        MidasPhase <> 'C'
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   IF        CoBRunData <> *blanks
     C                   EVAL      TotalN = AlreadyRun
     C                   EVAL      Value = TotalA
     C                   ELSE
     C                   EVAL      Value = *blanks
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Failed components
     C                   IF        Key_Desc = 'NoOfFailedCoBCmps'
      * Retrieve data.
     C                   IN        CoBStatus
      *
      * If the Midas phase is not CoB then set data to blank.
     C                   IF        MidasPhase <> 'C'
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   IF        NFCM = '000' or
     C                             NFCM = *blanks
     C                   EVAL      Value = *blanks
     C                   ELSE
     C                   EVAL      Value = NFCM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C/COPY GOCPYSRC,GOUPD_DWNL
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
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   SetOn                                        U7U8                   BUG9512
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
