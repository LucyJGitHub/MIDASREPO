     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Database Update')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200160 - Midas SD Network Description Maintenance    *
      *                   (Database Update)                           *
      *                                                               *
      *  Function:  This module updates the files related to a        *
      *             Network Description                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL146             Date 10Jul13               *
      *                 251316             Date 05Nov07               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  CSD101 - Password Encryption (Recompile)                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_011, CGL146_027     *
      *                        CGL146_028, CGL146_029, CGL146_030     *
      *                        CGL146_031, CGL146_032                 *
      *  251316 - MT940 not produced in COB.  Additional validation   *
      *           when amending Network description to avoid incorrect*
      *           deletion of record in GLNWKAPD.                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FSDNWRKL0  UF A E           K DISK    INFSR(*PSSR) RENAME(@EDREJY:SDNWRKD0)
     F                                     COMMIT
      ** Midas Message Network Details
      *

     FGLNWKAPD  UF A E           K DISK    INFSR(*PSSR) COMMIT
      ** Midas GL Network Activity Control File
      *

     FSDFCTLL0  UF A E           K DISK    INFSR(*PSSR) RENAME(@AHREAU:SDFCTLD0)
     F                                     COMMIT
      ** Midas SD Standing Data Controls
      *
     F/COPY OFCPYSRCZ,CGL146_027                                                              CGL146

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access SDNWRKL0                                                   *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
      *

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================
      *

      ** Named constants
      ** ---------------
      *

      ** Arrays and Data Structures
      ** --------------------------
      *

     D CurFilRcd     E DS                  EXTNAME(SDNWRKPD)
      ** Current Network File Record (i.e. state of the record when entering this module)
      *

     D PrvFilRcd     E DS                  EXTNAME(SDNWRKPD) PREFIX(PRV_)
      ** Previous Network File Record (i.e. initial state of the record)
      *

     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD) PREFIX(NEW_)
      ** New Network File Record (i.e. new state after amendments)
      *

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
     D/COPY OFCPYSRCZ,CGL146_028                                                              CGL146

      ** Declared variables
      ** ------------------
      *
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    ActionCode
     C                   PARM                    PrvFilRcd
     C                   PARM                    NewFilRcd
     C/COPY OFCPYSRCZ,CGL146_011                                                              CGL146

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Process updating according to the action code
      *
     C                   SELECT

      ** -- Insert a record
      *
     C                   WHEN      ActionCode = 'I'
     C                   EXSR      $InsertRcd

      ** -- Update a record
      *
     C                   WHEN      ActionCode = 'A'
     C                   EXSR      $UpdateRcd

      ** -- Delete a record
      *
     C                   WHEN      ActionCode = 'D'
     C                   EXSR      $DeleteRcd

     C                   ENDSL

      ** End of the module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*

      *========================================================================*
      * $InsertRcd: Insert a new record                                        *
      *------------------------------------------------------------------------*
     C     $InsertRcd    BEGSR
      *    ----------    ------
      ** Record already exists ==> Error

     C                   IF        NOT *IN27
     C                   MOVE      'USR3989'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** Insert the new record
      *
     C                   MOVEL     NewFilRcd     CurFilRcd
     C                   EVAL      EDLCD  = AGRDNB
     C                   EVAL      EDTYLC = 'I'
     C                   WRITE     SDNWRKD0
     C/COPY OFCPYSRCZ,CGL146_029                                                              CGL146
      *    ----------    ------
     C     @InsertRcd    ENDSR

      *========================================================================*
      * $UpdateRcd: Update a record                                            *
      *------------------------------------------------------------------------*
     C     $UpdateRcd    BEGSR
      *    ----------    ------
      ** Record not found ==> Error
      *
     C                   IF        *IN27
     C                   MOVE      'USR3990'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** If record already modified by another user ==> Error
      *
     C                   IF        CurFilRcd <> PrvFilRcd
     C                   MOVE      'USR3991'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** Amend the record
      *
     C                   MOVEL     NewFilRcd     CurFilRcd
     C                   EVAL      EDLCD  = AGRDNB
     C                   EVAL      EDTYLC = 'A'
     C                   UPDATE    SDNWRKD0
     C/COPY OFCPYSRCZ,CGL146_030                                                              CGL146
      *    ----------    ------
     C     @UpdateRcd    ENDSR

      *========================================================================*
      * $DeleteRcd: Delete a record                                            *
      *------------------------------------------------------------------------*
     C     $DeleteRcd    BEGSR
      *    ----------    ------
      ** Record not found ==> Error
      *
     C                   IF        *IN27
     C                   MOVE      'USR3992'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** If record already modified by another user ==> Error
      *
     C                   IF        CurFilRcd <> PrvFilRcd
     C                   MOVE      'USR3993'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** Logically delete the record
      *
     C                   EVAL      EDLCD  = AGRDNB
     C                   EVAL      EDTYLC = 'D'
     C                   UPDATE    SDNWRKD0
      *    ----------    ------
     C     @DeleteRcd    ENDSR

      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR

      *========================================================================*
      * $ExitMod  : Update the related files and exit from the module          *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** Simply exit if something went wrong
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   GOTO      #ExitMod
     C                   ENDIF

      ** Update of GLNWKAPD - Midas GL Network Activity Control File
      *
      ** -- A record should be created if the network allows MT941/42 generation
      **    The creation should not occur for deletion
      *
     C                   IF        ActionCode <> 'D' AND
     C                             (EDM941 = 'Y' OR EDM942 = 'Y')
     C     EDNWRK        CHAIN     GLNWKAD0                           99

     C                   IF        *IN99
     C                   EVAL      MTNWRK = EDNWRK
     C                   EVAL      MTSSTS = 'I'
     C                   WRITE     GLNWKAD0
     C                   ENDIF

     C                   ENDIF

      ** -- An eventual record should be deleted if the network has been deleted
      **    or if the MT941/42 generation indicators were both changed from 'Y'
      **    to 'N'
      *
     C                   IF        ActionCode = 'D' OR
     C**********                   (EDM941 <> 'Y' AND EDM942 <> 'Y')                          251316
     C                             (EDM941 <> 'Y' AND EDM942 <> 'Y' AND                       251316
     C                              EDM940 <> 'Y' AND EDM950 <> 'Y')                          251316
     C     EDNWRK        CHAIN     GLNWKAD0                           99

     C                   IF        NOT *IN99
     C                   DELETE    GLNWKAD0
     C                   ENDIF

     C                   ENDIF

      ** Update of SDFCTLL0 - Midas SD Standing Data Controls
      *
     C     'SDNWRKPD  '  CHAIN     SDFCTLD0                           99

     C                   IF        *IN99
     C                   CLEAR                   SDFCTLD0
     C                   MOVEL     'SDNWRKPD  '  AHFLNM
     C                   ENDIF

     C                   SELECT
     C                   WHEN      ActionCode = 'I'
     C                   ADD       1             AHNOIN
     C                   ADD       1             AHNORC

     C                   WHEN      ActionCode = 'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC

     C                   OTHER
     C                   ADD       1             AHNOAM
     C                   ENDSL

     C                   IF        *IN99
     C                   WRITE     SDFCTLD0
     C                   ELSE
     C                   UPDATE    SDFCTLD0
     C                   ENDIF

      ** Exit from the module
      *
     C     #ExitMod      TAG
      *    ----------    ------
     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR

      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80

      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10

      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF

     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7

      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
     C/COPY OFCPYSRCZ,CGL146_031                                                              CGL146

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks

      ** Access file on the specified Key
      *
     C     NEW_EDNWRK    CHAIN     SDNWRKD0                           27
     C/COPY OFCPYSRCZ,CGL146_032                                                              CGL146
      *    ----------    ------
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On

     C                   CALLB     'DBERRCTL'

     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
