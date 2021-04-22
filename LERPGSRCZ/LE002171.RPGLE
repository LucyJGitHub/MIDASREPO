     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Facilities Extension File Take-On')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE002171 - Midas LE Facilities Extension File Take-On        *
      *             Program                                           *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CLE168             Date 26Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE147  *CREATE    Date 28Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CLE168 - Allow Debit of Blocked Account (Recompile)          *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE147 - Aggregate Facility                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas LE Facility file by credit agreement
     FLEFCLTLE  IF   E           K DISK    INFSR(*PSSR)

      ** Midas LE Facilities Ext File by branch
     FLEFCLTLG  UF   E           K DISK    INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+

      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,STD_D_SPEC

     D WFACT           S              3A
     D WFCNO           S              2A

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C     FCLTKEY       KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    WFACT
     C                   KFLD                    WFCNO
     C
      ** Read all records in Lending Facility File by Credit Agreement

     C     *LOVAL        SETLL     LEFCLTLE
     C                   READ      LEFCLTLE
     C                   DOW       NOT %EOF(LEFCLTLE)

     C                   MOVE      FACT          WFACT
     C                   MOVE      FCNO          WFCNO
     C     FCLTKEY       CHAIN     LEFCLTLG

     C                   IF        %FOUND(LEFCLTLG)

     C                   IF        FCCANM = *BLANKS
     C                             AND FCCAFT = *BLANKS
     C                             AND FCCAFN = *BLANKS
     C                   EVAL      FCCANM = CANM
     C                   MOVE      CAFT          FCCAFT
     C                   MOVE      CAFN          FCCAFN
     C                   UPDATE    LEFCLTD0
     C                   ENDIF

     C                   ENDIF

     C                   READ      LEFCLTLE

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN

     C                   ENDSR
