     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee Read')                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMRED - LE Fee Read                                      *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Fee file.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEFEEML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LeFeedf:LeFeemF0)
     FLEFEEML1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LeFeedf:LeFeemF1)
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LeFeedf:LeFeedF1)
     FLEFEEDL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LeFeedf:LeFeedF3)
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
     C                   MOVEL     *BLANK        @LNRFR
     C                   MOVEL     *BLANK        @FSEQR
      *
      ***  Check for user authority to browse if not multi-branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate Fee ref (for pointer)
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
      * RDFWD - Read forwards through Fee file
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
     C     @@FRNT        SETGT     LeFeemF1
     C                   ELSE
     C     @@FRNT        SETGT     LeFeemF0
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @@FEER        SETGT     LEFeedF3
     C                   ELSE
     C     @@FEER        SETGT     LEFeedF1
     C                   END
     C                   END
      *
      ***  Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     FERECI        OREQ      'D'
     C     @@ERR         ANDEQ     *ZERO
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READ      LeFeemF1                               99
     C                   ELSE
     C                   READ      LeFeemF0                               99
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READ      LEFeedF3                               99
     C                   ELSE
     C                   READ      LEFeedF1                               99
     C                   END
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at Fee  (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    FEBRCA
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
     C     DDLNRF        ANDEQ     *BLANKS
     C     DDFSEQ        ANDEQ     *BLANKS
     C     FOTRID        ANDEQ     *BLANKS
     C                   MOVEL     'LEV9000'     @ERRMS
     C                   ELSE
     C                   MOVEL     'LEV9001'     @ERRMS
     C                   END
      *
      ***  Else, return the Fee number read
      *
     C                   ELSE
     C                   MOVE      FECNUM        @CNUMR
     C     FEFACL        IFNE      *ZERO
     C                   MOVEL     FEFACL        @FACTR
     C                   MOVE      FEFACL        @FCNOR
     C                   END
 
     C*****FELOAN        IFNE      *ZERO                                                      CLE148
     C     FELOAN        IFNE      *BLANKS                                                    CLE148
     C                   MOVE      FELOAN        @LNRFR
     C                   END
 
     C                   MOVE      FEFSEQ        @FSEQR
     C                   MOVE      FRNT          @FTRED
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - Read backwards through Fee file
      *****************************************************************
     C     RDBCK         BEGSR
      *
      ***  Position to current record on file
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C     @@FRNT        SETLL     LeFeemF1
     C                   ELSE
     C     @@FRNT        SETLL     LeFeemF0
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @@FEER        SETLL     LEFeedF3
     C                   ELSE
     C     @@FEER        SETLL     LEFeedF1
     C                   END
     C                   END
      *
      ***  Initialize the check record flag
      *
      ***  Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     FERECI        OREQ      'D'
     C     @@ERR         ANDEQ     *ZERO
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READP     LeFeemF1                               99
     C                   ELSE
     C                   READP     LeFeemF0                               99
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READP     LEFeedF3                               99
     C                   ELSE
     C                   READP     LEFeedF1                               99
     C                   END
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    FEBRCA
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
      ***  Else, return the Fee      read
      *
     C                   ELSE
     C                   MOVE      FECNUM        @CNUMR
     C     FEFACL        IFNE      *ZERO
     C                   MOVEL     FEFACL        @FACTR
     C                   MOVE      FEFACL        @FCNOR
     C                   END
 
     C*****FELOAN        IFNE      *ZERO                                                      CLE148
     C     FELOAN        IFNE      *BLANKS                                                    CLE148
     C                   MOVE      FELOAN        @LNRFR
     C                   END
 
     C                   MOVE      FEFSEQ        @FSEQR
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
      * VALDLN - Validate Fee ref pointer
      *****************************************************************
     C     VALDLN        BEGSR
      *
     C                   MOVE      FOTRID        @@FRNT           20
     C                   MOVEL     DDCSSN        @@CNUMR
     C                   MOVEL     DDFACT        @@FACLR
     C                   MOVE      DDFCNO        @@FACLR
     C                   MOVEL     DDLNRF        @@LNRFR
     C                   MOVEL     DDFSEQ        @@FSEQR
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
      ***  Fee ref pointer
     C                   PARM                    DDCSSN           10
      *
      ***  Fee ref pointer
     C                   PARM                    DDFACT            3
      *
      ***  Fee ref pointer
     C                   PARM                    DDFCNO            2
      *
      ***  Fee ref pointer
     C                   PARM                    DDLNRF            6
      *
      ***  Fee ref pointer
     C                   PARM                    DDFSEQ            2
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
      ***  Fee ref pointer
     C                   PARM                    @CNUMR            6
      *
      ***  Fee ref pointer
     C                   PARM                    @FACTR            3
      *
      ***  Fee ref pointer
     C                   PARM                    @FCNOR            2
      *
      *
      ***  Fee ref pointer
     C                   PARM                    @LNRFR            6
      *
      ***  Fee ref pointer
     C                   PARM                    @FSEQR            2
      *
      ***  Front Office Fee Read
     C                   PARM                    @FTRED           20
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFEEMRED'   DBPGM
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
      ***  Key list for Fee file
      *
     C     @@FEER        KLIST
     C**********         KFLD                    @@CNUMR           6 0                        CSD027
     C                   KFLD                    @@CNUMR           6                          CSD027
     C                   KFLD                    @@FACLR           5 0
     C**********         KFLD                    @@LNRFR           6 0                        CLE148
     C                   KFLD                    @@LNRFR           6                          CLE148
     C                   KFLD                    @@FSEQR           2 0
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
