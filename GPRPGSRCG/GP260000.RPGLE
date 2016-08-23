     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access Global Reserved Transactions')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP260000 - Access Global Reserved Transactions               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Prev Amend No. CAP207   *CREATE   Date 10Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
 
      ** Midas RE Reserved Transactions by RTREF
 
     FGPMLRSL1  IF   E           K DISK    INFSR(*PSSR)
 
     D LDA           E DS           256    EXTNAME(LDA)
     D                                     DTAARA(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'
 
     D/COPY GPCPYSRCG,PSDS
      ** Program Status Data Structure
 
      ** Entry Parameters
 
     D PRef            S                   LIKE(RTREF)
     D PAsstAmt        S                   LIKE(RTASSETAMT)
 
      ** Work fields
 
     D WRun            S              1A   INZ(' ')
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read record from File
 
     C     KrtRef        SETLL     GPMLRSL1
     C     KrtRef        READE     GPMLRSL1
 
     C                   DOW       Not %Eof
 
     C                   EVAL      PAsstAmt = PAsstAmt + RTASSETAMT
 
     C     KrtRef        READE     GPMLRSL1
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Receive Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRef
     C                   PARM                    PAsstAmt
 
      ** Keys for GPMLRSL1
 
     C     KrtRef        KLIST
     C                   KFLD                    PRef
 
      ** Initialise LDA field
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = 1
     C                   EVAL      DBPGM = 'GP250000'
     C                   OUT       LDA
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
