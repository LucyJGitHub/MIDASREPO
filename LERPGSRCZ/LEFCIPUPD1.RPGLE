     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility BoE database update')                *
      *****************************************************************
      *                                                               *
      *  Midas - LE Customer Lending                                  *
      *                                                               *
      *  LEFCIPUPD1 - Update of the extension file BYFCLTXO           *
      *               database                                        *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FBYFCLTY1  UF A E           K DISK    COMMIT
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
 
     DValidFCIPEx    E DS                  EXTNAME(LEVFCIPX0)
 
     D PRTCD           S             10
     D ACTN            S              1
     D @RETURN         S              6
     D @TYPE           S              1
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
     C     WKEYFLD       KLIST
     C                   KFLD                    LVCNUM
     C                   KFLD                    LVFACT
     C                   KFLD                    LVFCNO
 
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
     C                   PARM                    PRTCD
     C                   PARM                    ACTN
     C                   PARM                    ValidFCIPEx
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SRUPDAT       BEGSR
 
     C     WKEYFLD       CHAIN     BYFCLTY1                             50
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
      *****************************************************************
      *                                                               *
      * INSERT - Insert a transaction                                 *
      *                                                               *
      *****************************************************************
 
     C     INSERT        BEGSR
 
      ** Initialise Transaction Detail
 
     C                   CLEAR                   BYFCLTD0
 
      ** Set Transaction fields on insert
 
     C                   EVAL      LCNUM = LVCNUM
     C                   EVAL      LFACT = LVFACT
     C                   EVAL      LFCNO = LVFCNO
     C                   EVAL      LEURO = LVEURO
 
      ** Write/UPDATE Transaction Detail
 
     C                   IF        NOT %FOUND(BYFCLTY1)
     C                   WRITE     BYFCLTD0
     C                   ELSE
     C                   UPDATE    BYFCLTD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AMEND  - Amend a transaction                                  *
      *                                                               *
      *****************************************************************
 
     C     AMEND         BEGSR
 
      ** Set Transaction Detail fields on amend
 
     C                   EVAL      LCNUM = LVCNUM
     C                   EVAL      LFACT = LVFACT
     C                   EVAL      LFCNO = LVFCNO
     C                   EVAL      LEURO = LVEURO
 
      ** Update/Write Transaction Detail
 
     C                   IF        %FOUND(BYFCLTY1)
     C                   UPDATE    BYFCLTD0
     C                   ELSE
     C                   WRITE     BYFCLTD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DELETE - Delete a transaction                                 *
      *                                                               *
      *****************************************************************
 
     C     DELETE        BEGSR
 
      ** Access Transaction Details
 
     C                   IF        %FOUND(BYFCLTY1)
 
      ** Delete record
 
     C                   DELETE    BYFCLTD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
