     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Account Transfer Update GEICPD')
      *****************************************************************
      *                                                               *
      *  Midas - Optional Features Module                             *
      *                                                               *
      *  GL009701 - Midas OF Account Transfer Update GEICPD           *
      *                                                               *
      *  Function:  This program updates GL Gen.Entries Int.Cap.Detail*
      *             GEICPD  with the new account details from the     *
      *             Account Transfer Selected Accounts File, GLSLACPD *
      *             It also will write an audit trail record for each *
      *             update of GEICPD                                  *
      *                                                               *
      *  Called By: GL003600                                          *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060782 *CREATE    Date 02Feb23              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060782 - Account Transfer Utility                          *
      *                                                               *
      *****************************************************************
      *  Function of Indicators                                       *
      *                                                               *
      *  01 - 19      Input Control.                                  *
      *  20 - 29      I/O Conditioning (ie. CHAIN, LOKUP etc...)      *
      *   20          Record Not Found                                *
      *   21          File Error Occurred                             *
      *   22          Start/End Of File Reached                       *
      *   25          Lookup/Scan.                                    *
      *  30 - 39      Program Work Indicators                         *
      *  40 - 49      Output Control.                                 *
      *  50 - 89      Output Conditioning (ie. Cursor Positioning)    *
      *  90 - 99      Error Control.                                  *
      *****************************************************************
      *
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D GLAU          E DS                  EXTNAME(GLAUTFPD)
     D APOS          E DS                  EXTNAME(GEICPD) PREFIX(G_)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D DSFRAC          DS
     D  DSFCNU                 1      6
     D  DSFCCY                 7      9
     D  DSFACO                10     19
     D  DSFACS                20     21
     D  DSFBRC                22     24
      *
     D DSTOAC          DS
     D  DSTCNU                 1      6
     D  DSTCCY                 7      9
     D  DSTACO                10     19
     D  DSTACS                20     21
     D  DSTBRC                22     24
      *
     D DSKITE          DS            90
     D  KBRCA                  1      3
     D  KCNUM                  4      9
     D  KCCY                  10     12
     D  KACOD                 13     22  0
     D  KACSQ                 23     24  0
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@PRCD            4
     C                   PARM                    P@RFNO           10
     C     DSFRAC        PARM                    P@FRAC           24
     C     DSTOAC        PARM                    P@TOAC           24
     C                   PARM                    P@RTCD            1
      *
     C                   EXSR      SRINIT
      *
     C     P@PRCD        IFEQ      '*LR '
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   EXSR      XMAPOS
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XMAPOS - Maintain GL Account Postings Detail                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     XMAPOS        BEGSR
      *
     C/exec SQL
     C+ Set Option COMMIT = *CHG
     C/end-exec
      *
     C/Exec SQL
     C+ Declare cAPOST Scroll Cursor For
     C+  Select * From GEICPD
     C+   Where BRCA = :DSFBRC and CNUM = :DSFCNU and
     C+         CCY = :DSFCCY and ACOD = :DSFACO and
     C+         ACSQ = :DSFACS
     C+   For Update of BRCA, CNUM, CCY, ACOD, ACSQ
     C/End-Exec
      *
     C/Exec SQL
     C+ Open cAPOST
     C/End-Exec
      *
     C/Exec SQL
     C+ Fetch First
     C+   From cAPOST Into :APOS
     C/End-Exec
      *
      **   Error when Error Occurs during Read from GEICPD
      *
     C                   If        SQLCOD < 0
     C     *LOCK         In        LDA
     C                   Eval      DBASE = 1
     C                   Eval      DBFILE = 'GEICPD'
     C                   Eval      DBKEY = DSKITE
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
      **   Process Update to GEICPD and Insert to GLAUTFPD when Record is Read
      *
     C                   Dow       SQLSTT = '00000'
      *
      **   Update GEICPD
      *
     C/Exec SQL
     C+ Update GEICPD
     C+  Set BRCA = :DSTBRC, CNUM = :DSTCNU, CCY = :DSTCCY,
     C+      ACSQ = :DSTACS, ACOD = :DSTACO
     C+  Where Current of cAPOST
     C/End-Exec
      *
      **   Error when Update to GEICPD Fails
      *
     C                   If        SQLCod < 0
     C     *LOCK         In        LDA
     C                   Eval      DBASE = 2
     C                   Eval      DBFILE = 'GEICPD'
     C                   Eval      DBKEY = DSKITE
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
      **   Write Logs to GLAUTPFD
      *
     C                   Eval      AURFNO = P@RFNO
     C                   Eval      AUFILE = 'GEICPD '
     C                   Eval      AULFIL = *Blank
     C                   Eval      AUFBRC = DSFBRC
     C                   Eval      AUFCNU = DSFCNU
     C                   Eval      AUFACO = DSFACO
     C                   Eval      AUFACS = DSFACS
     C                   Eval      AUTBRC = DSTBRC
     C                   Eval      AUTCNU = DSTCNU
     C                   Eval      AUTACO = DSTACO
     C                   Eval      AUTACS = DSTACS
     C                   Eval      AUTEXT = %Char(G_PSTD) + ' ' + %Char(G_DRCR)
     C                                      + ' ' + %Char(G_PSTA) + ' ' + G_PNAR
     C                   Eval      AUCRTD = WKDFMT
      *
     C/Exec SQL
     C+ Insert Into GLAUTFPD Values(:GLAU)
     C/End-Exec
      *
      **   Error when Insert to GLAUTFPD failed
      *
     C                   If        SQLCod < 0
     C     *LOCK         In        LDA
     C                   Eval      DBASE = 1
     C                   Eval      DBFILE = 'GLAUTFPD'
     C                   Eval      DBKEY = AURFNO
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
     C/Exec SQL
     C+ Fetch Next
     C+   From cAPOST Into :APOS
     C/End-Exec
     C                   Enddo
      *
     C/Exec SQL
     C+ Close cAPOST
     C/End-Exec
      *
     C/Exec SQL
     C+ Commit
     C/End-Exec
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialise and define fields                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Retrieve Run Date.
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     @RTCD         ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'AOBANKR0'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     006           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     BJMRDT        WKDFMT            9
     C                   MOVE      BJMRDT        WKYEAR            2 0
      *
     C     WKYEAR        IFLT      72
     C     WKYEAR        ADD       2000          WKCCYY            4 0
     C                   ELSE
     C     WKYEAR        ADD       1900          WKCCYY
     C                   ENDIF
      *
     C                   MOVE      WKCCYY        WKDFMT            9
      *
     C     KAPOS         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
      *
     C                   MOVEL     DSFBRC        KBRCA
     C                   MOVEL     DSFCNU        KCNUM
     C                   MOVEL     DSFCCY        KCCY
     C                   MOVEL     DSFACO        KACOD
     C                   MOVEL     DSFACS        KACSQ
      *
     C                   CLEAR                   APOS
     C                   CLEAR                   GLAU
      *
     C                   ENDSR
      *
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
      *
     C     *PSSR         BEGSR
      *
      **   Reverse all Changes made to Files
      *
     C                   If        SQLSTT = '0200' or  SQLCOD < 0
     C/Exec SQL
     C+ Rollback
     C/End-Exec
     C                   Endif
      *
     C                   MOVE      'F'           P@RTCD
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
**  CPY@
(c) Finastra International Limited 2023
