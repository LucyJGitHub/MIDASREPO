     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Sold Read')                               *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASSRED - Negotiable Assets Sold read function             *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the negotiable assets sold file.          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP052             Date 25Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 12Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDENSPP *
      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMCMPLLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDELDP0)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDEAMP0)
     F                                     RENAME(MMDENSP0:MMCMPLP0)
     FMMCARDLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDELDP0)
     F                                     IGNORE(MMDENBP0)
     F                                     RENAME(MMDENSP0:MMCARDP0)
     FMMDEALL0  IF   E           K DISK    INFSR(*PSSR)                         CAP052
     F                                     IGNORE(MMDENBP0)                     CAP052
     F                                     IGNORE(MMDELDP0)                     CAP052
     F                                     RENAME(MMDENSP0:MMDEALP0)            CAP052
     FMMDEALL2  IF   E           K DISK    INFSR(*PSSR)                         CAP052
     F                                     IGNORE(MMDENBP0)                     CAP052
     F                                     IGNORE(MMDELDP0)                     CAP052
     F                                     RENAME(MMDENSP0:MMDEALP2)            CAP052
 
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
     C     @@FRNT        SETGT     MMDEALL2                                     CAP052
     C                   ELSE                                                   CAP052
     C     @@FRNT        SETGT     MMDEALL0                                     CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C     @@DLNO        SETGT     MMCMPLLL
     C                   ELSE
     C     @@DLNO        SETGT     MMCARDLL
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     HMDLTF        OREQ      ' '
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
     C                   READ      MMDEALL2                               99    CAP052
     C                   ELSE                                                   CAP052
     C                   READ      MMDEALL0                               99    CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C                   READ      MMCMPLLL                               99
     C                   ELSE
     C                   READ      MMCARDLL                               99
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * If multi-branching, check if authorized to look at deal (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    HMBRCA
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
     C                   MOVEL     'MMM1006'     @ERRMS
     C                   ELSE
     C                   MOVEL     'MMM1002'     @ERRMS
     C                   END
      *
      * Else, return the deal number read
      *
     C                   ELSE
     C                   MOVE      HMDN38        @DLRED
     C                   MOVE      HMFRNT        @FTRED                         CAP052
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
     C     @@FRNT        SETLL     MMDEALL2                                     CAP052
     C                   ELSE                                                   CAP052
     C     @@FRNT        SETLL     MMDEALL0                                     CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C     @@DLNO        SETLL     MMCMPLLL
     C                   ELSE
     C     @@DLNO        SETLL     MMCARDLL
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     HMDLTF        OREQ      ' '
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
     C                   READP     MMDEALL2                               99    CAP052
     C                   ELSE                                                   CAP052
     C                   READP     MMDEALL0                               99    CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C                   READP     MMCMPLLL                               99
     C                   ELSE
     C                   READP     MMCARDLL                               99
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * If multi-branching, check if authorized to look at deal (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    HMBRCA
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
      * Else, return the deal number read
      *
     C                   ELSE
     C                   MOVE      HMDN38        @DLRED
     C                   MOVE      HMFRNT        @FTRED                         CAP052
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
