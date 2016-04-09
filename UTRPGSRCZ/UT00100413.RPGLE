     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Stack Generation Report Input')               *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT00100413 - Midas UT Stack Generation Report Input          *
      *                                                               *
      *  Function:  This program will lists down all entry programs,  *
      *  (phase(s)) referenced programs and referenced levels. (IC)   *
      *                                                               *
      *  Called By: CLLE/UTC01011                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * W_SGEN - Write record to report file UTSG01PD                 *
      * C_DUPL - Check for duplicate record in UTSG01PD               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas UT UTSGENPD Record Entries - Distinct
     FV_UTSGENV0IF   E             DISK    RENAME(V_UTSGENV0:UTSGENV0)
     F                                     INFSR(*PSSR)
 
      ** Midas UT Stack Gen Engine Report File - Keyed
     FUTSG01L01 IF   E           K DISK    RENAME(UTSG01F:UTSG01M)
     F                                     PREFIX(A)
     F                                     INFSR(*PSSR)
 
      ** Midas UT Stack Generation Engine Report File
     FUTSG01PD  UF A E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D LVL             S                   LIKE(SGRLVL)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      ** Define Key List
 
     C     K_SGPR        KLIST
     C                   KFLD                    SGMPRG
     C                   KFLD                    SGRPRG
     C                   KFLD                    SGRLVL
 
      ** Initialize the sequence number
 
     C                   EVAL      SGSEQN = 0
 
     C                   READ      UTSGENV0
 
     C                   DOW       NOT %EOF
 
     C                   EXSR      W_SGEN
 
     C                   IF        LVL = 1
     C                   EVAL      SGRPRG = *BLANKS
     C                   EVAL      SGRLVL = 0
 
      ** Check if record already exists in file
      ** If YES, SGDTAG = 'Y'
 
     C                   EXSR      C_DUPL
 
     C                   EVAL      SGSEQN = SGSEQN + 1
 
     C                   WRITE     UTSG01F
     C                   ENDIF
 
     C                   READ      UTSGENV0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * W_SGEN - Write record to report file UTSG01PD                 *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: C_DUPL                                                 *
      *****************************************************************
     C     W_SGEN        BEGSR
 
     C                   EVAL      SGMPRG = MPGM
 
     C                   FOR       LVL = 1 to 20
 
     C                   SELECT
 
     C                   WHEN      LVL = 1
     C                   IF        PGM02 = *BLANKS
     C                   LEAVE
     C                   ENDIF
     C                   WHEN      LVL = 2
     C                   EVAL      SGRPRG = PGM02
     C                   WHEN      LVL = 3
     C                   EVAL      SGRPRG = PGM03
     C                   WHEN      LVL = 4
     C                   EVAL      SGRPRG = PGM04
     C                   WHEN      LVL = 5
     C                   EVAL      SGRPRG = PGM05
     C                   WHEN      LVL = 6
     C                   EVAL      SGRPRG = PGM06
     C                   WHEN      LVL = 7
     C                   EVAL      SGRPRG = PGM07
     C                   WHEN      LVL = 8
     C                   EVAL      SGRPRG = PGM08
     C                   WHEN      LVL = 9
     C                   EVAL      SGRPRG = PGM09
     C                   WHEN      LVL = 10
     C                   EVAL      SGRPRG = PGM10
     C                   WHEN      LVL = 11
     C                   EVAL      SGRPRG = PGM11
     C                   WHEN      LVL = 12
     C                   EVAL      SGRPRG = PGM12
     C                   WHEN      LVL = 13
     C                   EVAL      SGRPRG = PGM13
     C                   WHEN      LVL = 14
     C                   EVAL      SGRPRG = PGM14
     C                   WHEN      LVL = 15
     C                   EVAL      SGRPRG = PGM15
     C                   WHEN      LVL = 16
     C                   EVAL      SGRPRG = PGM16
     C                   WHEN      LVL = 17
     C                   EVAL      SGRPRG = PGM17
     C                   WHEN      LVL = 18
     C                   EVAL      SGRPRG = PGM18
     C                   WHEN      LVL = 19
     C                   EVAL      SGRPRG = PGM19
     C                   WHEN      LVL = 20
     C                   EVAL      SGRPRG = PGM20
 
     C                   ENDSL
 
     C                   EVAL      SGRLVL = LVL
 
     C                   IF        SGRPRG <> *BLANKS
 
      ** Check if record already exists in file
      ** If YES, SGDTAG = 'Y'
 
     C                   EXSR      C_DUPL
 
     C                   EVAL      SGSEQN = SGSEQN + 1
 
     C                   WRITE     UTSG01F
     C                   EVAL      SGRPRG = *BLANKS
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * C_DUPL - Check for duplicate record in UTSG01PD               *
      *                                                               *
      * Called by: W_SGEN                                             *
      *                                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     C_DUPL        BEGSR
 
     C     K_SGPR        SETLL     UTSG01M
     C     K_SGPR        READE     UTSG01M
 
     C                   IF        %EQUAL
     C                   EVAL      SGDTAG = 'Y'
     C                   ELSE
     C                   EVAL      SGDTAG = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
