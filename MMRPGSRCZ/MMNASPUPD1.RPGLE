     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA''s Purchased BoE Database Update')         *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  MMNASPUPD1 - Update of the extension file BYNASPY1           *
      *               database                                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. BUG7381            Date 31May05               *
      *                 LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG7381- Could not enter extension fields for deals entered  *
      *           before BOE was switched on                          *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FBYNASPY1  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
     D ExtData       E DS                  EXTNAME(MMNPEXPD)
     D PErrFlg         S              1
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
     C                   EXSR      SRUPDAT
 
     C                   RETURN
 
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    WDDLNO            6
     C                   PARM                    ACTN              1
     C                   PARM                    PRTCD             7
     C                   PARM                    ExtData
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN           6
     C                   PARM                    @TYPE             1
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
     C     SRUPDAT       BEGSR
 
     C                   MOVE      WDDLNO        WDDLNOX           6 0
 
     C     WDDLNOX       CHAIN     BYNASPY1                             50
     C                   IF        @TYPE = '1' AND *IN50 = '1'
     C                   EVAL      PRTCD = '*RECLCK'
     C                   RETURN
     C                   ENDIF
 
      ** Insert, Amend or Delete the transaction
 
     C     ACTN          CASEQ     'I'           INSERT
     C     ACTN          CASEQ     'A'           AMEND
     C     ACTN          CASEQ     'D'           DELETE
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * INSERT - Insert a transaction                                *
      *                                                              *
      ****************************************************************
     C     INSERT        BEGSR
 
      ** Access Transaction Details
 
     C     WDDLNOX       CHAIN     BYNASPY1
 
     C                   IF        NOT %FOUND(BYNASPY1)
 
      ** Initialise Transaction Detail
 
     C                   CLEAR                   BYNASPD0
 
      ** Set Transaction fields on insert
 
     C                   MOVE      WDDLNO        LDLNO
     C                   EVAL      LGTEE = LGTEEEX
     C                   EVAL      LQUAL = LQUALEX
     C                   MOVE      LFMATEX       LFMAT
      *
      ** Write new Transaction Detail
      *
     C                   WRITE     BYNASPD0
     C                   ELSE                                                                BUG7381
     C                   EVAL      LGTEE = LGTEEEX                                           BUG7381
     C                   EVAL      LQUAL = LQUALEX                                           BUG7381
     C                   MOVE      LFMATEX       LFMAT                                       BUG7381
     C                   UPDATE    BYNASPD0                                                  BUG7381
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * AMEND  - Amend a transaction                                 *
      *                                                              *
      ****************************************************************
     C     AMEND         BEGSR
 
      ** Access Transaction Detail record
 
     C     WDDLNOX       CHAIN     BYNASPY1
 
     C                   IF        %FOUND(BYNASPY1)
 
      ** Set Transaction Detail fields on amend
 
     C                   EVAL      LGTEE = LGTEEEX
     C                   EVAL      LQUAL = LQUALEX
     C                   MOVE      LFMATEX       LFMAT
 
      ** Update Record
 
     C                   UPDATE    BYNASPD0
     C                   ELSE                                                                BUG7381
     C                   CLEAR                   BYNASPD0                                    BUG7381
     C                   MOVE      WDDLNO        LDLNO                                       BUG7381
     C                   EVAL      LGTEE = LGTEEEX                                           BUG7381
     C                   EVAL      LQUAL = LQUALEX                                           BUG7381
     C                   MOVE      LFMATEX       LFMAT                                       BUG7381
     C                   WRITE     BYNASPD0                                                  BUG7381
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DELETE - Delete a transaction                                *
      *                                                              *
      ****************************************************************
     C     DELETE        BEGSR
 
      ** Access Transaction Details
 
     C     WDDLNOX       CHAIN     BYNASPY1
     C                   IF        %FOUND(BYNASPY1)
 
      ** Delete record
 
     C                   DELETE    BYNASPD0
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2005
