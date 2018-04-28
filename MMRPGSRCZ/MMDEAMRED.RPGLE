     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal Amendments Read')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMRED - DEAL AMENDMENTS READ                             *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Deal Amendments file.                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP052             Date 25Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMCMPLLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDELDP0)
     F                                     RENAME(MMDEAMP0:MMCMPLP0)
     FMMCARMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMCARMP0)
     FMMDEAML0  IF   E           K DISK    INFSR(*PSSR)                         CAP052
     F                                     RENAME(MMDEAMP0:MMDEAMP0)            CAP052
     FMMDEAML1  IF   E           K DISK    INFSR(*PSSR)                         CAP052
     F                                     RENAME(MMDEAMP0:MMDEAMP1)            CAP052
 
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
 
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
 
      **  Data Structure to split value date used in key to deams file
     D                 DS
     D  @KVALD                 1      8  0 INZ(0)
     D  @VDYY                  1      4  0
     D  @VYEAR                 3      4  0
     D  @VDMM                  5      6  0
     D  @VDDD                  7      8  0
 
     D                 DS
      **  Data Structure for screen value date
     D  ValueDate              1      6
     D  @DSPD                  1      2
     D  @DSPM                  3      4
     D  @DSPY                  5      6
 
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
     C                   MOVEL     *BLANK        @VDRED
     C                   MOVEL     *BLANK        @SQRED
     C                   MOVEL     *BLANK        @FTRED                         CAP052
     C                   MOVEL     *BLANK        @FARED                         CAP052
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ** Validate Deal Number / Value Date / Sequence No. combination.
      ** (FOR POINTER)
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
      * RDFWD - READ FORWARDS THROUGH DEAMS FILE
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
     C     @@FRNT        SETGT     MMDEAML1                                     CAP052
     C                   ELSE                                                   CAP052
     C     @@FRNT        SETGT     MMDEAML0                                     CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C     @DMKEY        SETGT     MMCMPLP0
     C                   ELSE
     C     @DMKEY        SETGT     MMCARMLL
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     HNDLTF        OREQ      ' '
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
     C                   READ      MMDEAML1                               99    CAP052
     C                   ELSE                                                   CAP052
     C                   READ      MMDEAML0                               99    CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C                   READ      MMCMPLP0                               99
     C                   ELSE
     C                   READ      MMCARMLL                               99
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * If multi-branching, check if authorized to look at deam (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    HNBRCA
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
      * Else, return the deal number, value date and sequence no. read
      *
     C                   ELSE
     C                   MOVE      HNDA38        @DLRED
     C                   Z-ADD     HNVDYY        @@YEAR
     C                   Z-ADD     HNVDMM        @@MNTH
     C                   Z-ADD     HNVDDD        @@DAY
     C                   MOVE      HNFRNT        @FTRED                         CAP052
     C                   MOVE      HNAFRT        @FARED                         CAP052
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        @VDRED
     C                   END
     C                   MOVE      HNDS38        @SQRED
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH DEAL AMENDMENTS FILE
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
     C     @@FRNT        SETLL     MMDEAML1                                     CAP052
     C                   ELSE                                                   CAP052
     C     @@FRNT        SETLL     MMDEAML0                                     CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C     @DMKEY        SETLL     MMCMPLP0
     C                   ELSE
     C     @DMKEY        SETLL     MMCARMLL
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     HNDLTF        OREQ      ' '
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
     C                   READP     MMDEAML1                               99    CAP052
     C                   ELSE                                                   CAP052
     C                   READP     MMDEAML0                               99    CAP052
     C                   ENDIF                                                  CAP052
     C                   ELSE                                                   CAP052
     C     DDACTN        IFEQ      'X'
     C                   READP     MMCMPLP0                               99
     C                   ELSE
     C                   READP     MMCARMLL                               99
     C                   END
     C                   ENDIF                                                  CAP052
      *
      * If multi-branching, check if authorized to look at deam (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    HNBRCA
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
      * Else, return the deal number, value date and sequence no. read
      *
     C                   ELSE
     C                   MOVE      HNDA38        @DLRED
     C                   Z-ADD     HNVDYY        @@YEAR
     C                   Z-ADD     HNVDMM        @@MNTH
     C                   Z-ADD     HNVDDD        @@DAY
     C                   MOVE      HNFRNT        @FTRED                         CAP052
     C                   MOVE      HNAFRT        @FARED                         CAP052
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        @VDRED
     C                   END
     C                   MOVE      HNDS38        @SQRED
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
      * VALDLN - VALIDATE DEAL NUMBER / VALUE DATE / SEQUENCE NUMBER
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
      **  Validate that the value date is a valid date or blank.
      *
     C                   MOVE      DDVDAT        ValueDate
     C     DDVDAT        IFNE      *BLANKS
     C                   TESTN                   DDVDAT               98
     C                   MOVE      DDVDAT        @@TEST
     C                   TESTZ                   @@TEST                   99
     C     *IN98         IFEQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVEL     DDVDAT        @DAT
     C                   CALL      'ZA0270'
     C                   PARM                    @DAT              6 0
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE            1
     C                   PARM                    @VDYNO            5 0
     C                   END
     C                   END
     C*
     C**  If the return code is 1 then the input date is invalid or
     C**  non-numeric.
     C     @RTCDE        IFEQ      '1'
     C     DDVDAT        ANDNE     *BLANKS
     C*
     C     *IN99         OREQ      '0'
     C     DDVDAT        ANDNE     *BLANKS
     C*
     C     *IN98         OREQ      '0'
     C     DDVDAT        ANDNE     *BLANKS
     C*
     C                   MOVEL     'MMM0125'     @ERRMS
     C                   RETURN
     C*
     C                   ELSE
     C     DDVDAT        IFEQ      *BLANKS
     C                   Z-ADD     *LOVAL        @VDYY
     C                   Z-ADD     *LOVAL        @VDMM
     C                   Z-ADD     *LOVAL        @VDDD
     C                   ELSE
     C*
     C** Load value date to numeric keyfield,in YYYYMMDD format
     C                   Z-ADD     0             @KVALD
     C                   MOVE      @DSPY         @VYEAR
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPD         @VDDD
     C                   ELSE
     C                   MOVE      @DSPD         @VDMM
     C                   END
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPM         @VDMM
     C                   ELSE
     C                   MOVE      @DSPM         @VDDD
     C                   END
     C*
     C** Century
     C     @VYEAR        IFGE      72
     C     @VDYY         ADD       1900          @VDYY
     C                   ELSE
     C     @VDYY         ADD       2000          @VDYY
     C                   END
     C                   END
     C                   END
      *
      ** Sequence no. must be numeric if entered
      *
     C     DDDS38        IFNE      *BLANKS
     C*
     C                   TESTN                   DDDS38               98
     C                   MOVE      DDDS38        @@TEST
     C                   TESTZ                   @@TEST                   99
     C                   END
     C*
     C     DDDS38        IFEQ      *BLANKS
     C*
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C*
     C     DDDS38        IFEQ      *BLANKS
     C                   Z-ADD     *LOVAL        @KSEQN
     C                   ELSE
     C                   MOVE      DDDS38        @KSEQN
     C                   END
     C*
     C                   ELSE
     C*
     C                   MOVEL     'MMM0196'     @ERRMS
     C                   RETURN
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM YYYYMMDD TO DDMMYY (OR MMDDYY)     *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZA0770'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@DTIN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         @@DTOU            6 0
      *
     C                   ENDSR
      *****************************************************************
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
      * DEAL NUMBER / VALUE DATE / SEQUENCE NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *                                                                         CAP052
      * Front Office Transaction ID                                             CAP052
     C                   PARM                    FOTRID           20            CAP052
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDDS38            3
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
      *                                                                         CAP052
      * Front Office Associated Deal Read                                       CAP052
     C                   PARM                    @FARED           20            CAP052
      *
      * VALUE DATE READ
     C                   PARM                    @VDRED            6
      *
      * SEQUENCE NUMBER READ
     C                   PARM                    @SQRED            3
      *
      ** Deam key fields
      *
     C     @DMKEY        KLIST
     C                   KFLD                    @@DLNO
     C                   KFLD                    @VDYY
     C                   KFLD                    @VDMM
     C                   KFLD                    @VDDD
     C                   KFLD                    @KSEQN            3 0
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMDEAMRED'   DBPGM
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
(c) Misys International Banking Systems Ltd. 2001
