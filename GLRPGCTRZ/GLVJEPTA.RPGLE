     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JEPTAx Posting amount')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLVJEPTA - Validate Posting amount                           *
      *                                                               *
      *  Function:  This module receives parameters containing a      *
      *             Posting amount and confirm wether it is a valid   *
      *             Posting amount or not                             *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      ***Component*of:**SP122CTYLX*-*Core*Luxembourg*service*program***                       CER001
      *  Component of:  SP6GL0004  - Core service program             *                       CER001
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001             Date 25Apr05               *
      *  Prev Amend No. ULX607  *CREATE    Date 13Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX607 - API Luxembourg - Function GLBITP                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
     D                 DS
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for currency details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #7LXPTAF        S             14A
     D #7LXOPCF        S              3A
     D #1CYCD          S              3A
     D #DFMPA          S             14A
     D WPTAF           S             13P 0
 
      ** Define parameters for call module
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
     D ZFLD15          S             15P 0
     D ZDECS           S              1P 0
     D ZECODE          S              1A
 
     D @AORC           S              7A
     D @FMPA           S             23A
     D @NBDP           S              1P 0
     D @AMNT           S             15P 0
 
     D @KEY1           S              3A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ** Access currency codes to retrieve A6NBDP
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1CYCD        @KEY1
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     *BLANKS       DBKEY                          ****************
     C                   MOVEL     #1CYCD        DBKEY                          * DB ERROR 900 *
     C                   EXSR      *PSSR                                        ****************
     C                   ENDIF
      *
      ** Convert transaction amount from character to numeric
      *
     C                   CALL      'GL0132U'
     C                   PARM      *BLANK        @AORC
     C                   PARM      #DFMPA        @FMPA
     C                   PARM      A6NBDP        @NBDP
     C                   PARM      *ZERO         @AMNT
      *
     C                   Z-ADD     *ZERO         WPTAF
     C     #7LXPTAF      IFNE      *BLANKS
     C     #7LXOPCF      IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10018'     #MSGID
     C                   GOTO      #ERROR
      *
      ** Check if numeric
      *
     C                   ELSE
     C                   MOVE (P)  #7LXPTAF      ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ** Input is not valid
      *
     C     ZALIGNok      IFEQ      'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10015'     #MSGID
     C                   GOTO      #ERROR
      *
     C                   ELSE
     C                   MOVE      *BLANKS       ZECODE
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      ZFIELD        WPTAF
     C                   Z-ADD     WPTAF         ZFLD15
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZOUT21
      *
     C                   MOVE      ZOUT20        #7LXPTAF
      *
      ** The amount must be greater than zero
     C     WPTAF         IFEQ      *ZEROS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10015'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C     #7LXOPCF      IFNE      *BLANKS
      *
     C                   MOVE      *BLANKS       ZECODE
     C                   Z-ADD     A6NBDP        ZDECS
     C                   Z-ADD     @AMNT         ZFLD15
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZOUT21
      *
     C                   MOVE      ZOUT20        #7LXPTAF
     C                   Z-ADD     @AMNT         WPTAF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #7LXPTAF
     C                   PARM                    #7LXOPCF
     C                   PARM                    #1CYCD
     C                   PARM                    #DFMPA
     C                   PARM                    WPTAF
      *
      ** Set the program, module and procedure names for database
      ** error processing.  Note: this /COPY requires that the PSDS
      ** /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
