     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade read')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SETRADRED - SECURITIES TRADES READ                           *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the trades file.                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE019             Date 04Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 02Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE019 - SE Trades Selections Enhancements                   *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *           Recompiled due to database changes                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * Trades file
     FTRADS     IF   E           K DISK    INFSR(*PSSR)
 
      * Trades requiring autorization
     FTRADTA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRADSDF:TRADSRA)
                                                                                CSE019
      * Trades details - By Front Office Id                                     CSE019
     FSETRADL0  IF   E           K DISK    INFSR(*PSSR)                         CSE019
     F                                     RENAME(TRADSDF:TRADSL0)              CSE019
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
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
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * INITIALIZE OUTPUTS
      *
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        @TRRED
     C                   MOVEL     *BLANK        @FTRED                         CSE019
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * VALIDATE TRADE REF. (FOR POINTER)
      *
     C                   EXSR      VALTRF
      *
      * READ FORWARDS
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      * READ BACKWARDS
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      RDBCK
     C                   END
     C                   END
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - READ FORWARDS THROUGH TRADES FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
      *                                                                         CSE019
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'                     CSE019
      * Do position with front office ID on file                                CSE019
      *                                                                         CSE019
     C     ModeofOp      IFEQ      '*FRONT'                                     CSE019
     C     @@FRNT        SETGT     SETRADL0                                     CSE019
     C                   ELSE                                                   CSE019
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
     C     @@TDRF        SETGT     TRADSRA
     C                   ELSE
     C     @@TDRF        SETGT     TRADS
     C                   ENDIF
     C                   ENDIF                                                  CSE019
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     TDRF          ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
      *
      * Read
      *                                                                         CSE019
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'                     CSE019
      * Do position with front office ID on file                                CSE019
      *                                                                         CSE019
     C     ModeofOp      IFEQ      '*FRONT'                                     CSE019
     C                   READ      SETRADL0                               99    CSE019
     C                   ELSE                                                   CSE019
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
     C                   READ      TRADSRA                                99
     C                   ELSE
     C                   READ      TRADS                                  99
     C                   ENDIF
     C                   ENDIF                                                  CSE019
      *
      * If multi-branching, check if authorized to look at trade (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    TDBA
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     DDTDRF        IFEQ      *BLANKS
     C     FOTRID        ANDEQ     *BLANKS                                      CSE019
     C                   MOVEL     'MMM1006'     @ERRMS
     C                   ELSE
     C                   MOVEL     'MMM1002'     @ERRMS
     C                   END
      *
      * Else, return the trade reference read
      *
     C                   ELSE
     C                   MOVE      TDRF          @TRRED
     C                   MOVEL     FRNT          @FTRED                         CSE019
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH TRADES FILE
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
      *
      *                                                                         CSE019
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'                     CSE019
      *                                                                         CSE019
     C     ModeofOp      IFEQ      '*FRONT'                                     CSE019
     C     @@FRNT        SETLL     SETRADL0                                     CSE019
     C                   ELSE                                                   CSE019
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
     C     @@TDRF        SETLL     TRADSRA
     C                   ELSE
     C     @@TDRF        SETLL     TRADS
     C                   ENDIF
     C                   ENDIF                                                  CSE019
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     TDRF          ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
      *
      * Read authorized/not authorized
      *
      *                                                                         CSE019
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'                     CSE019
      *                                                                         CSE019
     C     ModeofOp      IFEQ      '*FRONT'                                     CSE019
     C                   READP     SETRADL0                               99    CSE019
     C                   ELSE                                                   CSE019
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
     C                   READP     TRADSRA                                99
     C                   ELSE
     C                   READP     TRADS                                  99
     C                   ENDIF
     C                   ENDIF                                                  CSE019
      *
      * If multi-branching, check if authorized to look at trade (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    TDBA
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      * If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MMM1003'     @ERRMS
      *
      * Else, return the trade reference read
      *
     C                   ELSE
     C                   MOVE      TDRF          @TRRED
     C                   MOVEL     FRNT          @FTRED                         CSE019
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTRF - VALIDATE TRADE REFERENCE POINTER
      *****************************************************************
     C     VALTRF        BEGSR
      *                                                                         CSE019
     C                   MOVE      FOTRID        @@FRNT           20            CSE019
      *
      **  Validate that the trade ref is numeric or blank.
      *
     C                   TESTN                   DDTDRF               98
     C                   MOVE      DDTDRF        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDTDRF        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      DDTDRF        @@TDRF            6
      *
      * RETURN ERROR MESSAGE
      *
     C                   ELSE
     C                   MOVEL     'MMM0162'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Trade Ref. pointer
      * Read Forwards
      * Read Backwards
     C                   PARM                    RetCodeIn
      *                                                                         CSE019
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CSE019
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CSE019
      *                                                                         CSE019
     C                   PARM                    ModeofOp          6            CSE019
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDRF            6
      *                                                                         CSE019
      * Front Office Transaction ID                                             CSE019
     C                   PARM                    FOTRID           20            CSE019
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
      * OUTPUT PARAMETERS :
      * Error meassage
      * Trade Ref. Read
     C                   PARM                    @ERRMS            7
     C                   PARM                    @TRRED            6
      *                                                                         CSE019
      * Front Office Deal Read                                                  CSE019
     C                   PARM                    @FTRED           20            CSE019
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADRED'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
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
(c) Finastra International Limited 2001
