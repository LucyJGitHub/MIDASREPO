     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility read')                               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFCIPRED - LE Facility Read                                 *
      *                                                               *
      *  Function:  This module reads forwards and backwards stomer   *
      *             through the Facility file.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEFCIPL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL0)
     FLEFCIPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL1)
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
     FLEFCLTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFC1)
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @@RCDTR         S              1A   INZ('A')
      *
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
      ***  Initialize outputs
      *
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        @CNUMR
     C                   MOVEL     *BLANK        @FACTR
     C                   MOVEL     *BLANK        @FCNOR
      *
      ***  Check for user authority to browse if not multi-branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate Fclty ref (for pointer)
      *
     C                   EXSR      VALDLN
      *
      ***  Read forwards
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      ***  Read backwards
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      RDBCK
     C                   END
     C                   END
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through loans file
      *****************************************************************
     C     RDFWD         BEGSR
      *
      ***  Position to current record on file
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      ***  Do position with front office ID on file
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C     @@FRNT        SETGT     FCLTYFL1
     C                   ELSE
     C     @@FRNT        SETGT     FCLTYFL0
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @@FACR        SETGT     FCLTYFC1
     C                   ELSE
     C     @@FACR2       SETGT     FCLTYFMF
     C                   END
     C                   END
      *
      ***  Initialize the check record flag
      *
     C****               MOVEL     'N'           @@FND             1
      *
      ***  Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     RECI          OREQ      'D'
     C     @@ERR         ANDEQ     *ZERO
     C**** @@FND         ANDEQ     'Y'
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READ      FCLTYFL1                               99
     C                   ELSE
     C                   READ      FCLTYFL0                               99
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READ      FCLTYFC1                               99
     C                   ELSE
     C                   READ      FCLTYFMF                               99
     C                   END
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      ***  If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     DDCSSN        IFEQ      *BLANKS
     C     DDFACT        ANDEQ     *BLANKS
     C     DDFCNO        ANDEQ     *BLANKS
     C     FOTRID        ANDEQ     *BLANKS
     C                   MOVEL     'LEV9000'     @ERRMS
     C                   ELSE
     C                   MOVEL     'LEV9001'     @ERRMS
     C                   END
      *
      ***  Else, return the Fclty number read
      *
     C                   ELSE
     C                   MOVE      CNUM          @CNUMR
     C                   MOVE      FACT          @FACTR
     C                   MOVE      FCNO          @FCNOR
     C                   MOVE      FRNT          @FTRED
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - Read backwards through Fclty file
      *****************************************************************
     C     RDBCK         BEGSR
      *
      ***  Position to current record on file
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C     @@FRNT        SETLL     FCLTYFL1
     C                   ELSE
     C     @@FRNT        SETLL     FCLTYFL0
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @@FACR        SETLL     FCLTYFC1
     C                   ELSE
     C     @@FACR2       SETLL     FCLTYFMF
     C                   END
     C                   END
      *
      ***  Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     RECI          OREQ      'D'
     C     @@ERR         ANDEQ     *ZERO
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READP     FCLTYFL1                               99
     C                   ELSE
     C                   READP     FCLTYFL0                               99
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READP     FCLTYFC1                               99
     C                   ELSE
     C                   READP     FCLTYFMF                               99
     C                   END
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      ***  If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'LEV9002'     @ERRMS
      *
      ***  Else, return the Facility read
      *
     C                   ELSE
     C                   MOVE      CNUM          @CNUMR
     C                   MOVE      FACT          @FACTR
     C                   MOVE      FCNO          @FCNOR
     C                   MOVE      FRNT          @FTRED
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for user authority if not multi-branching
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ***  Return error message
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'LEV9003'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALDLN - Validate Facility ref pointer
      *****************************************************************
     C     VALDLN        BEGSR
      *
     C                   MOVE      FOTRID        @@FRNT           20
      *
     C                   MOVEL     DDCSSN        @@CNUMR
     C                   MOVEL     DDFACT        @@FACTR
     C                   MOVEL     DDFCNO        @@FCNOR
      *
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUT PARAMETERS
      *
      ***  RETURN CODE
     C                   PARM                    RetCodeIn
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      ***  Action code
     C                   PARM                    DDACTN            1
      *
      ***  Facility ref pointer
     C                   PARM                    DDCSSN           10
      *
      ***  Facility ref pointer
     C                   PARM                    DDFACT            3
      *
      ***  Facility ref pointer
     C                   PARM                    DDFCNO            2
      *
      ***  Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ***  Read forwards
     C                   PARM                    @RDFWD            1
      *
      ***  Read backwards
     C                   PARM                    @RDBCK            1
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    @ERRMS            7
      *
      ***  Facility ref pointer
     C                   PARM                    @CNUMR            6
      *
      ***  Facility ref pointer
     C                   PARM                    @FACTR            3
      *
      ***  Facility ref pointer
     C                   PARM                    @FCNOR            2
      *
      ***  Front Office Fclty Read
     C                   PARM                    @FTRED           20
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFCIPRED'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Key list for Facility files
      *
     C     @@FACR        KLIST
     C**********         KFLD                    @@CNUMR           6 0                        CSD027
     C                   KFLD                    @@CNUMR           6                          CSD027
     C                   KFLD                    @@FACTR           3 0
     C                   KFLD                    @@FCNOR           2 0
      *
     C     @@FACR2       KLIST
     C                   KFLD                    @@CNUMR
     C                   KFLD                    @@FACTR
     C                   KFLD                    @@FCNOR
     C                   KFLD                    @@RCDTR
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
(c) Misys International Banking Systems Ltd. 2002
