     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees Read')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFERED - Dealing Fees Read                                *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Dealing Fees file.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting.  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FDLFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     FDLFEEDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLDLFED2)
     FDLFEEDL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLDLFED3)
     FDLFEEDL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLDLFED4)
 
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
     C                   MOVEL     *BLANK        @SQRED
     C                   MOVEL     *BLANK        @FTRED
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ** Validate Deal Number / Sequence No. combination.
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
      * RDFWD - READ FORWARDS THROUGH DL FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
      *
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      * Do position with front office ID on file
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C     @@FRNT        SETGT     DLFEEDL3
     C                   ELSE
     C     @@FRNT        SETGT     DLFEEDL2
     C                   ENDIF
      *
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @DLKEY        SETGT     DLFEEDL4
     C                   ELSE
     C     @DLKEY        SETGT     DLFEEDL1
     C                   END
     C                   ENDIF
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     @@ERR         OREQ      *ZERO
      *
      * Read from complete or requires authorization
      * or   from authorized
      *
      *
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READ      DLFEEDL3                               99
     C                   ELSE
     C                   READ      DLFEEDL2                               99
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READ      DLFEEDL4                               99
     C                   ELSE
     C                   READ      DLFEEDL1                               99
     C                   END
     C                   ENDIF
      *
      * If multi-branching, check if authorized to look at DLFE (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    DFBRCA
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     DDDLNO        IFEQ      *BLANKS
     C     FOTRID        ANDEQ     *BLANKS
     C                   MOVEL     'MMM1006'     @ERRMS
     C                   ELSE
     C                   MOVEL     'MMM1002'     @ERRMS
     C                   END
      *
      * Else, return the deal number and sequence no. read
      *
     C                   ELSE
     C                   MOVE      DFDLNO        @DLRED
     C                   MOVE      DFFSEQ        @SQRED
     C                   MOVE      DFFRNT        @FTRED
      *
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
      *
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C     @@FRNT        SETLL     DLFEEDL3
     C                   ELSE
     C     @@FRNT        SETLL     DLFEEDL2
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @DLKEY        SETLL     DLFEEDL4
     C                   ELSE
     C     @DLKEY        SETLL     DLFEEDL1
     C                   END
     C                   ENDIF
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     @@ERR         OREQ      *ZERO
      *
      * Read from complete or requires authorization
      * or   from authorized
      *
      *
      * If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READP     DLFEEDL3                               99
     C                   ELSE
     C                   READP     DLFEEDL2                               99
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READP     DLFEEDL4                               99
     C                   ELSE
     C                   READP     DLFEEDL1                               99
     C                   END
     C                   ENDIF
      *
      * If multi-branching, check if authorized to look at deam (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    DFBRCA
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
      * Else, return the deal number and sequence no. read
      *
     C                   ELSE
     C                   MOVE      DFDLNO        @DLRED
     C                   MOVE      DFFSEQ        @SQRED
     C                   MOVE      DFFRNT        @FTRED
      *
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
      * VALDLN - VALIDATE DEAL NUMBER / SEQUENCE NUMBER
      *****************************************************************
     C     VALDLN        BEGSR
      *
     C                   MOVE      FOTRID        @@FRNT           20
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
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER / SEQUENCE NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
     C                   PARM                    DDDS38            2
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
      *
      * Front Office Deal Read
     C                   PARM                    @FTRED           20
      *
      * SEQUENCE NUMBER READ
     C                   PARM                    @SQRED            2
      *
      ** DLFE key fields
      *
     C     @DLKEY        KLIST
     C                   KFLD                    @@DLNO
     C                   KFLD                    @KSEQN            2 0
      *
      ** Initialize program name
      *
     C                   MOVEL     'DLDLFERED'   DBPGM
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
