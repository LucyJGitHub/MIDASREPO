     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal Read')                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXFXDLRED - FX DEAL READ                                     *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the FX deals file.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP052             Date 22Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXDEALPP *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CDL008 - Continuous Linked Settlement (Recompile)            *
      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFXCODLLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXCODLL0)
     FFXRAUTLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXRAUTL0)
     FFXDEALL0  IF   E           K DISK    INFSR(*PSSR)                         CAP052
     F                                     RENAME(FXDEALP0:FXDEALD0)            CAP052
     FFXDEALL1  IF   E           K DISK    INFSR(*PSSR)                         CAP052
     F                                     RENAME(FXDEALP0:FXDEALD1)            CAP052

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

      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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
     C                   MOVEL     *BLANK        @DLRED
     C                   MOVEL     *BLANK        @FTRED                         CAP052
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * VALIDATE DEAL NUMBER (FOR POINTER)
      *
     C                   EXSR      VALDLN
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
      * RDFWD - READ FORWARDS THROUGH DEALS FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
      *                                                                         CAP052
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'                     CAP052
      * Do position with front office ID on file                                CAP052
      *                                                                         CAP052
     C     ModeofOp      IFEQ      '*FRONT'                                     CAP052
     C     DDACTN        IFEQ      'X'                                          CAP052
     C     @@FRNT        SETGT     FXDEALL1                                     CAP052
     C                   ELSE                                                   CAP052
     C     @@FRNT        SETGT     FXDEALL0                                     CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C     @@DLNO        SETGT     FXCODLLL
     C                   ELSE
     C     @@DLNO        SETGT     FXRAUTLL
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     FHDLTF        OREQ      ' '
     C     @@ERR         ANDEQ     *ZERO
      *
      * Read from complete or requires authorization
      * or   from authorized
      *
      *                                                                         CAP052
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'                     CAP052
      *                                                                         CAP052
     C     ModeofOp      IFEQ      '*FRONT'                                     CAP052
     C     DDACTN        IFEQ      'X'                                          CAP052
     C                   READ      FXDEALL1                               99    CAP052
     C                   ELSE                                                   CAP052
     C                   READ      FXDEALL0                               99    CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C                   READ      FXCODLLL                               99
     C                   ELSE
     C                   READ      FXRAUTLL                               99
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * If multi-branching, check if authorized to look at deal (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    FHDBRC
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     DDDLNO        IFEQ      *BLANKS
     C     FOTRID        ANDEQ     *BLANKS                                      CAP052
     C                   MOVEL     'FXM1006'     @ERRMS
     C                   ELSE
     C                   MOVEL     'FXM1002'     @ERRMS
     C                   END
      *
      * Else, return the deal number read
      *
     C                   ELSE
     C                   MOVE      FHDN38        @DLRED
     C                   MOVE      FHFRNT        @FTRED                         CAP052
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH DEALS FILE
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
      *
      *                                                                         CAP052
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'                     CAP052
      *                                                                         CAP052
     C     ModeofOp      IFEQ      '*FRONT'                                     CAP052
     C     DDACTN        IFEQ      'X'                                          CAP052
     C     @@FRNT        SETLL     FXDEALL1                                     CAP052
     C                   ELSE                                                   CAP052
     C     @@FRNT        SETLL     FXDEALL0                                     CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C     @@DLNO        SETLL     FXCODLLL
     C                   ELSE
     C     @@DLNO        SETLL     FXRAUTLL
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     FHDLTF        OREQ      ' '
     C     @@ERR         ANDEQ     *ZERO
      *
      * Read from complete or requires authorization
      * or   from authorized
      *
      *                                                                         CAP052
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'                     CAP052
      *                                                                         CAP052
     C     ModeofOp      IFEQ      '*FRONT'                                     CAP052
     C     DDACTN        IFEQ      'X'                                          CAP052
     C                   READP     FXDEALL1                               99    CAP052
     C                   ELSE                                                   CAP052
     C                   READP     FXDEALL0                               99    CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C                   READP     FXCODLLL                               99
     C                   ELSE
     C                   READP     FXRAUTLL                               99
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * If multi-branching, check if authorized to look at deal (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    FHDBRC
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      * If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'FXM1003'     @ERRMS
      *
      * Else, return the deal number read
      *
     C                   ELSE
     C                   MOVE      FHDN38        @DLRED
     C                   MOVE      FHFRNT        @FTRED                         CAP052
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
      * VALDLN - VALIDATE DEAL NUMBER POINTER
      *****************************************************************
     C     VALDLN        BEGSR
      *                                                                         CAP052
     C                   MOVE      FOTRID        @@FRNT           20            CAP052
      *
      **  Validate that the deal number is numeric or blank.
      *
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDDLNO        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      DDDLNO        @@DLNO            6 0
      *
      * RETURN ERROR MESSAGE
      *
     C                   ELSE
     C                   MOVEL     'FXM0162'     @ERRMS
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
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *                                                                         CAP052
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
      *                                                                         CAP052
     C                   PARM                    ModeofOp          6            CAP052
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *                                                                         CAP052
      * Front Office Transaction ID                                             CAP052
     C                   PARM                    FOTRID           20            CAP052
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM                    @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM                    @DLRED            6
      *                                                                         CAP052
      * Front Office Deal Read                                                  CAP052
     C                   PARM                    @FTRED           20            CAP052
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXFXDLRED'   DBPGM
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
