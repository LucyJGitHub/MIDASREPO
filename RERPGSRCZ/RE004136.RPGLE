     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retrieve Teller-ID from user')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004136 - Retrieve the Teller-ID from user profile          *
      *                                                               *
      *  Function:  This program retrieve and validate the teller-id. *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TDA035  *CREATE    Date 25Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *  TDA035 - RTS Signon changes for MidasPlus.                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDTELD        E DS                  EXTNAME(SDTELDPD)
      ** Teller ID Details
 
     D P@USER        E DS                  EXTNAME(MUSERDD)
      ** User detail
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs - long data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs - short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Entry Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    P#USER           10
     C                   PARM                    P#TLID            3
     C                   PARM                    P#MSGID           7
 
     C                   MOVE      *BLANKS       ReturnCode
     C                   MOVE      *BLANKS       P#MSGID
     C                   MOVE      *BLANKS       P#TLID
     C                   MOVE      *BLANKS       @RTCD
 
      ** Get the Teller-ID from MUSER
 
     C                   IF        P#USER <> *BLANKS
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @KEYD             8
     C                   PARM      P#USER        @USER            10
     C     P@USER        PARM      P@USER        DSSDY
 
      ** User not found on the system/current zone
 
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'USR0712'     P#MSGID
 
      ** Validate Teller-ID
 
     C                   ELSE
     C                   EXSR      SRVTEL
     C                   ENDIF
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FREE  '     @KEYD
     C                   PARM      P#USER        @USER
     C     P@USER        PARM      P@USER        DSSDY
 
      ** ZMUSER has no user profile
 
     C                   ELSE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  End the program
 
     C                   MOVEL     @RTCD         ReturnCode
     C                   MOVE      '1'           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTEL - Validate Teller-ID                                  *
      *                                                               *
      *****************************************************************
     C     SRVTEL        BEGSR
 
      **  The user profile has no Teller-ID
 
     C     TLID          IFEQ      *BLANKS
     C     TLID          OREQ      *ZEROS
 
     C                   MOVEL     'USR0700'     P#MSGID
 
     C                   ELSE
 
      **  The Teller-ID must exist on Tellers file
 
     C                   CALL      'AOTELDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      TLID          @TLID             3
     C     SDTELD        PARM      SDTELD        DSFDY
 
      ** Return Teller-ID to input parameter
      ** Else, Teller-ID not found
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     TLID          P#TLID
     C                   ELSE
     C                   MOVEL     TLID          P#TLID
     C                   MOVEL     'USR0701'     P#MSGID
     C                   END
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
