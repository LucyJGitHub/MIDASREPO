     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Repo margin calls display')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPMCDSP - Repo Margin Calls Display                        *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the Repo Margin Calls screen input function.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CSE006             Date 26Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CSE006 - Repurchase Agreement Enhancements                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMRPMCDF  CF   E             WORKSTN
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *                                                               *
      *       68  Protect deal key fields (action code & deal number) *
      *       69  Protect deal detail fields                          *
      *       70  Enable CF12                                         *
      *       71  Enable CF15                                         *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      ********************************************************************
      /EJECT
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)
 
     D @EI             S              1    DIM(60)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D MMRPMC        E DS                  EXTNAME(MMRPMCPD)
     D MMERPM        E DS                  EXTNAME(MMERPMCPD)
 
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Main processing
      *
     C                   EXSR      MAIN
      *
      * Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C* MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     MMERPM        @EI
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     30            E                 2 0
      *
     C     C             DOUGT     6
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      *  DO WHILE ERROR MESSAGES FOUND
      *  WRITE ERROR MESSAGES (WITH OR WITHOUT DATA) TO SUBFILE
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   @MSGID            7
     C                   MOVEL     MsgDtaArr(C)  @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   END
     C                   ADD       1             C
     C                   END
      *
      *  DO WHILE WARNING MESSAGES FOUND
      *  WRITE WARNING MESSAGES (WITH OR WITHOUT DATA) TO SUBFILE
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  @MSGID            7
     C                   MOVEL     WMsgDtaArr(C) @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   END
     C                   ADD       1             C
     C                   END
      *
      * If DlAmdInd is 'N' enable Action code, Deal no, Value date and
      * Cash/Securities and protect Repo type, Type and Amount
      *
     C                   IF        DlAmdInd = 'N'
     C                   EVAL      *IN41 = *Off
     C                   ELSE
     C                   EVAL      *IN41 = *On
     C                   ENDIF
      *
      * If DlPtcInd is 'N' enable Amount and Transaction Type fields
      *
     C                   IF        DlPtcInd = 'Y'
     C                   EVAL      *IN42 = *On
     C                   ELSE
     C                   EVAL      *IN42 = *Off
     C                   ENDIF
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKL        COMP      'Y'                                    70
     C     @EINKP        COMP      'Y'                                    71
      *
      * TEXT = SUCCESSFUL INSERT
      *
     C     @SIDN         IFNE      *BLANK
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @SIDN         DDSIDN
     C                   MOVEL     *BLANK        @SIDN
     C                   ELSE
      *
      * TEXT = CONFIRM DELETE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANK        DDFOTX
     C                   END
     C                   END
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     MMRPMCS0
     C**********         WRITE     MMRPMCD1                                                 AR656294
     C                   WRITE     MMRPMCF1
     C                   WRITE     MMRPMCD1                                                 AR656294
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      MMRPMCD1                               99    *
     C                   ENDIF
      *
      * Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     '000000'      *IN(30)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKP         @INKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ERRWOD  - OUTPUT ERROR MESSAGES WITHOUT DATA                  *
     C*                                                               *
     C*****************************************************************
     C     ERRWOD        BEGSR
     C*
     C*  Display error message
     C*
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID           10
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ERRWID  - OUTPUT ERROR MESSAGES WITH DATA                     *
     C*                                                               *
     C*****************************************************************
     C     ERRWID        BEGSR
     C*
     C*  Display error message
     C*
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C                   CALL      'ZA0440'
     C                   PARM                    ZAMSID           10
     C                   PARM      @MSGDT        ZAMDTA           45
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    MMRPMC
      *
      * FIELDS IN ERROR
     C                   PARM                    MMERPM
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED FUNCTION KEYS
      * KL = COMMAND KEY 12 = PREVIOUS SCREEN
      * KL = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKL            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *
      * Deal Amend Indicator
     C                   PARM                    DlAmdInd          1
      * Deal Protect indicator
     C                   PARM                    DlPtcInd          1
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMRPMCDSP'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @NAR
Deal No. 999999 successfully inserted.
F10=CONFIRM DELETE
