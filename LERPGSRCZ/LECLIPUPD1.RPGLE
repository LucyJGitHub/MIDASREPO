     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans BoE Database Update')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIPUPD1 - LE Customer Loans BoE Database Update           *
      *                                                               *
      *  Function:  This will handle the update of the extension      *
      *               file BYLOANX0                                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022  *CREATE    Date 24Jan05               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      /TITLE    S U B R O U T I N E   I N D E X .                     *
      *                                                               *
      *     Subroutine Index                                          *
      *     ================                                          *
      *                                                               *
      *     1. SRUPDAT   -   Update Processing                        *
      *     2. *INZSR    -   First time routine                       *
      *     3. *PSSR     -   Database Error Handling                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       89      CHAIN to BYLOANX0 Failed                        *
      *       88      CHAIN to BYLOANX0 - record is locked            *
      *                                                               *
      *****************************************************************
      *
      ** Input Files
      *
      ** Extension file (retrieval)
      *
     FBYLOANY1  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** Action Code
     D ACTN            S              1A
     D PRTCD           S              7A
 
     D @RETURN         S              6A
     D @TYPE           S              1A
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
     D ValidCLIPEx   E DS                  EXTNAME(LEVCLIPX0)
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      *****************************************************************
      *
      ** Update BYLOANX0
      *
     C                   EXSR      SRUPDAT
      *
      ** Exit From Program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDAT - Update the transaction details                      *
      *                                                               *
      *****************************************************************
     C     SRUPDAT       BEGSR
      *
      ** Access Transaction Detail record
      *
     C     LVLNRF        CHAIN     BYLOANY1                           8988
      *
      ** If in interactive mode
      *
     C                   IF        @TYPE = '1'
      *
      ** If record is locked
      *
     C                   IF        *IN88 = *ON
     C                   EVAL      PRTCD  = '*RECLCK'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** If Amend/Insert mode,
      *
     C                   EVAL      LLNRF = LVLNRF
     C                   EVAL      LLNTP = LVLNTP
     C                   EVAL      LFMAT = LVFMAT
      *
      ** If record is NOT locked and exists in extension file,
      ** amend record
      *
     C                   IF        *IN89 = *OFF
     C                   UPDATE    BYLOAND0
      *
      ** If record is NOT locked and does not exists in extension file,
      ** insert record
      *
     C                   ELSE
     C                   WRITE     BYLOAND0
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Return Code
      *
     C                   PARM                    PRTCD
      *
      ** Action Code
      *
     C                   PARM                    ACTN
      *
      ** Externally described DS for valid Transaction Detail
      *
     C                   PARM                    ValidCLIPEx
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
      *
     C                   ENDSR
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2005
