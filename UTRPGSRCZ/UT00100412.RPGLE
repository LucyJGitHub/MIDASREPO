     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Stack Generation Hierarchy Creator')          *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT00100412 - Midas UT Stack Generation Hierarchy Creator     *
      *                                                               *
      *  Function:  This program will lists down all entry programs   *
      *  (phase(s)) together with its called programs and subsequent  *
      *             subprograms. (IC)                                 *
      *                                                               *
      *  Called By: CLLE/UTC01011                                     *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * CHK_EL - Check endless loop possibilities                     *
      * C_DUPL - Check for duplicate record in UTSGENPD               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FV_UTPREF2 IF   E             DISK    RENAME(V_UTPREF2:V_UTPREF0)
     F                                     INFSR(*PSSR)
 
     FUTPREFL01 IF   E           K DISK    PREFIX(A)
     F                                     INFSR(*PSSR)
 
     FUTPREFL02 IF   E           K DISK    RENAME(UTPREFF:PREFF02)
     F                                     PREFIX(B)
     F                                     INFSR(*PSSR)
 
     FUTPREFL03 IF   E           K DISK    RENAME(UTPREFF:PREFF03)
     F                                     PREFIX(C)
     F                                     INFSR(*PSSR)
 
     FUTPREFL04 IF   E           K DISK    RENAME(UTPREFF:PREFF04)
     F                                     PREFIX(D)
     F                                     INFSR(*PSSR)
 
     FUTPREFL05 IF   E           K DISK    RENAME(UTPREFF:PREFF05)
     F                                     PREFIX(E)
     F                                     INFSR(*PSSR)
 
     FUTPREFL06 IF   E           K DISK    RENAME(UTPREFF:PREFF06)
     F                                     PREFIX(F)
     F                                     INFSR(*PSSR)
 
     FUTPREFL07 IF   E           K DISK    RENAME(UTPREFF:PREFF07)
     F                                     PREFIX(G)
     F                                     INFSR(*PSSR)
 
     FUTPREFL08 IF   E           K DISK    RENAME(UTPREFF:PREFF08)
     F                                     PREFIX(H)
     F                                     INFSR(*PSSR)
 
     FUTPREFL09 IF   E           K DISK    RENAME(UTPREFF:PREFF09)
     F                                     PREFIX(I)
     F                                     INFSR(*PSSR)
 
     FUTPREFL10 IF   E           K DISK    RENAME(UTPREFF:PREFF10)
     F                                     PREFIX(J)
     F                                     INFSR(*PSSR)
 
     FUTPREFL11 IF   E           K DISK    RENAME(UTPREFF:PREFF11)
     F                                     PREFIX(K)
     F                                     INFSR(*PSSR)
 
     FUTPREFL12 IF   E           K DISK    RENAME(UTPREFF:PREFF12)
     F                                     PREFIX(L)
     F                                     INFSR(*PSSR)
 
     FUTPREFL13 IF   E           K DISK    RENAME(UTPREFF:PREFF13)
     F                                     PREFIX(M)
     F                                     INFSR(*PSSR)
 
     FUTPREFL14 IF   E           K DISK    RENAME(UTPREFF:PREFF14)
     F                                     PREFIX(N)
     F                                     INFSR(*PSSR)
 
     FUTPREFL15 IF   E           K DISK    RENAME(UTPREFF:PREFF15)
     F                                     PREFIX(O)
     F                                     INFSR(*PSSR)
 
     FUTPREFL16 IF   E           K DISK    RENAME(UTPREFF:PREFF16)
     F                                     PREFIX(P)
     F                                     INFSR(*PSSR)
 
     FUTPREFL17 IF   E           K DISK    RENAME(UTPREFF:PREFF17)
     F                                     PREFIX(Q)
     F                                     INFSR(*PSSR)
 
     FUTPREFL18 IF   E           K DISK    RENAME(UTPREFF:PREFF18)
     F                                     PREFIX(R)
     F                                     INFSR(*PSSR)
 
     FUTPREFL19 IF   E           K DISK    RENAME(UTPREFF:PREFF19)
     F                                     PREFIX(S)
     F                                     INFSR(*PSSR)
 
     FUTPREFL20 IF   E           K DISK    RENAME(UTPREFF:PREFF20)
     F                                     PREFIX(T)
     F                                     INFSR(*PSSR)
 
     FUTSGENL0  IF   E           K DISK    RENAME(UTSGENF:UTSGENM)
     F                                     PREFIX(A)
     F                                     INFSR(*PSSR)
 
     FUTSGENPD  UF A E             DISK    INFSR(*PSSR)
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D ALLOBJ          C                   CONST('*ALL      ')
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     DDSGEN            DS           200
     D MPGM                    1     10
     D PGM02                  11     20
     D PGM03                  21     30
     D PGM04                  31     40
     D PGM05                  41     50
     D PGM06                  51     60
     D PGM07                  61     70
     D PGM08                  71     80
     D PGM09                  81     90
     D PGM10                  91    100
     D PGM11                 101    110
     D PGM12                 111    120
     D PGM13                 121    130
     D PGM14                 131    140
     D PGM15                 141    150
     D PGM16                 151    160
     D PGM17                 161    170
     D PGM18                 171    180
     D PGM19                 181    190
     D PGM20                 191    200
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D TAGGED          S              1    INZ('N')
     D KPREF           S                   LIKE(WHPNAM)
     D W_OBJ           S                   LIKE(WHPNAM)
     D POS             S              5U 0 INZ(*ZERO)
 
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
     C                   KFLD                    MPGM
     C                   KFLD                    PGM02
     C                   KFLD                    PGM03
     C                   KFLD                    PGM04
     C                   KFLD                    PGM05
     C                   KFLD                    PGM06
     C                   KFLD                    PGM07
     C                   KFLD                    PGM08
     C                   KFLD                    PGM09
     C                   KFLD                    PGM10
     C                   KFLD                    PGM11
     C                   KFLD                    PGM12
     C                   KFLD                    PGM13
     C                   KFLD                    PGM14
     C                   KFLD                    PGM15
     C                   KFLD                    PGM16
     C                   KFLD                    PGM17
     C                   KFLD                    PGM18
     C                   KFLD                    PGM19
     C                   KFLD                    PGM20
 
      ** Entry Program
 
     C                   IF        W_OBJ = ALLOBJ
     C                   READ      V_UTPREF2                              11
     C                   ELSE
     C                   EVAL      *IN11 = *OFF
     C                   EVAL      WHPNAM = W_OBJ
     C                   ENDIF
 
     C                   DOW       *IN11 = *OFF
     C                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = WHPNAM
 
      ** Level 01
 
     C     KPREF         SETLL     UTPREFL01
     C     KPREF         READE     UTPREFL01
     C                   EVAL      MPGM = KPREF
 
     C                   DOW       NOT %EOF
     C                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = AWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 02
 
     C     KPREF         SETLL     UTPREFL02
     C     KPREF         READE     UTPREFL02
     C                   EVAL      PGM02 = KPREF
 
     C                   DOW       NOT %EOF
     C                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = BWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 03
 
     C     KPREF         SETLL     UTPREFL03
     C     KPREF         READE     UTPREFL03
     C                   EVAL      PGM03 = KPREF
 
     C                   DOW       NOT %EOF
     C                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = CWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 04
 
     C     KPREF         SETLL     UTPREFL04
     C     KPREF         READE     UTPREFL04
     C                   EVAL      PGM04 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = DWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 05
 
     C     KPREF         SETLL     UTPREFL05
     C     KPREF         READE     UTPREFL05
     C                   EVAL      PGM05 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = EWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 06
 
     C     KPREF         SETLL     UTPREFL06
     C     KPREF         READE     UTPREFL06
     C                   EVAL      PGM06 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = FWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 07
 
     C     KPREF         SETLL     UTPREFL07
     C     KPREF         READE     UTPREFL07
     C                   EVAL      PGM07 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = GWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 08
 
     C     KPREF         SETLL     UTPREFL08
     C     KPREF         READE     UTPREFL08
     C                   EVAL      PGM08 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = HWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 09
 
     C     KPREF         SETLL     UTPREFL09
     C     KPREF         READE     UTPREFL09
     C                   EVAL      PGM09 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = IWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 10
 
     C     KPREF         SETLL     UTPREFL10
     C     KPREF         READE     UTPREFL10
     C                   EVAL      PGM10 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = JWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 11
 
     C     KPREF         SETLL     UTPREFL11
     C     KPREF         READE     UTPREFL11
     C                   EVAL      PGM11 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = KWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 12
 
     C     KPREF         SETLL     UTPREFL12
     C     KPREF         READE     UTPREFL12
     C                   EVAL      PGM12 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = LWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 13
 
     C     KPREF         SETLL     UTPREFL13
     C     KPREF         READE     UTPREFL13
     C                   EVAL      PGM13 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = MWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 14
 
     C     KPREF         SETLL     UTPREFL14
     C     KPREF         READE     UTPREFL14
     C                   EVAL      PGM14 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = NWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 15
 
     C     KPREF         SETLL     UTPREFL15
     C     KPREF         READE     UTPREFL15
     C                   EVAL      PGM15 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = OWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 16
 
     C     KPREF         SETLL     UTPREFL16
     C     KPREF         READE     UTPREFL16
     C                   EVAL      PGM16 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = PWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 17
 
     C     KPREF         SETLL     UTPREFL17
     C     KPREF         READE     UTPREFL17
     C                   EVAL      PGM17 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = QWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 18
 
     C     KPREF         SETLL     UTPREFL18
     C     KPREF         READE     UTPREFL18
     C                   EVAL      PGM18 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = RWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 19
 
     C     KPREF         SETLL     UTPREFL19
     C     KPREF         READE     UTPREFL19
     C                   EVAL      PGM19 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = SWHFNAM
     C                   EXSR      CHK_EL
 
      ** Level 20
 
     C     KPREF         SETLL     UTPREFL20
     C     KPREF         READE     UTPREFL20
     C                   EVAL      PGM20 = KPREF
 
     C                   DOW       NOT %EOF
     c                   EVAL      TAGGED = 'N'
     C                   EVAL      KPREF = TWHFNAM
     C                   EXSR      CHK_EL
 
     C                   EXSR      C_DUPL
     C                   READE     UTPREFL20
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM20
     C                   READE     UTPREFL19
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM19
     C                   READE     UTPREFL18
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM18
     C                   READE     UTPREFL17
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM17
     C                   READE     UTPREFL16
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM16
     C                   READE     UTPREFL15
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM15
     C                   READE     UTPREFL14
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM14
     C                   READE     UTPREFL13
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM13
     C                   READE     UTPREFL12
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM12
     C                   READE     UTPREFL11
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM11
     C                   READE     UTPREFL10
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM10
     C                   READE     UTPREFL09
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM09
     C                   READE     UTPREFL08
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM08
     C                   READE     UTPREFL07
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM07
     C                   READE     UTPREFL06
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM06
     C                   READE     UTPREFL05
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM05
     C                   READE     UTPREFL04
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM04
     C                   READE     UTPREFL03
     C                   ENDDO
 
     C                   EXSR      C_DUPL
     C                   CLEAR                   PGM03
     C                   READE     UTPREFL02
     C                   ENDDO
 
     C                   EXSR      C_DUPL
 
     C                   CLEAR                   PGM02
     C                   READE     UTPREFL01
     C                   ENDDO
 
     C                   EXSR      C_DUPL
 
     C                   CLEAR                   MPGM
 
     C                   IF        W_OBJ = ALLOBJ
     C                   READ      V_UTPREF2                              11
     C                   ELSE
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHK_EL - Check endless loop possibilities                     *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     CHK_EL        BEGSR
 
     C                   EVAL      POS = %SCAN(KPREF:DSGEN)
     C                   IF        POS > 0
     C                   EVAL      KPREF = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * C_DUPL - Check for duplicate record in UTSGENPD               *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     C_DUPL        BEGSR
 
     C                   IF        TAGGED = 'N'
 
     C     K_SGPR        SETLL     UTSGENM
     C     K_SGPR        READE     UTSGENM
 
     C                   IF        NOT %EQUAL
     C                   WRITE     UTSGENF
     C                   ENDIF
 
     C                   EVAL      TAGGED = 'Y'
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    W_OBJ
 
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
