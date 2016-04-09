     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Non-Currency OTC read function')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCORED - Non-Currency OTCs read function                  *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Futures and Options currency OTCs     *
      *             file.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Exchange-traded transactions file
     FFFOTCCL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Instrument types
     FINTYP     IF   E           K DISK    INFSR(*PSSR) PREFIX(IT)
 
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
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  NoRecFnd              02     02
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
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
 
      ** Initialise outputs
 
     C                   EVAL      @ERRMS = *BLANKS
     C                   EVAL      @TRRED = *BLANKS
 
      ** Check for user authority to browse if not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
 
      ** Validate transaction number.
      ** (for pointer)
 
     C                   EXSR      VALTRN
 
      ** Read forwards
 
     C                   IF        @RDFWD = 'Y'
     C                   EXSR      RDFWD
     C                   ELSE
 
      ** Read backwards
 
     C                   IF        @RDBCK = 'Y'
     C                   EXSR      RDBCK
     C                   ENDIF
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through transactions file
      *****************************************************************
 
     C     RDFWD         BEGSR
 
      ** Position to current record on file
 
     C     @@TNBR        SETGT     FFOTCCL0
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       EndOfFile = True or @@ERR = *ZERO
 
      ** Read from transaction file
 
     C                   READ      FFOTCCL0                               01
 
      ** If multi-branching, check if authorized to look at trade (based
      **  on branch) but if invalid continue searching for valid branch
 
     C                   IF        BJSBRC = *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   ENDIF
 
     C                   IF        EndOfFile = False and @@ERR = *ZERO
 
      ** Access INTYP to get instrument processing type
 
     C     ISTT          CHAIN     INTYP                              02
 
      ** If record not found
 
     C                   IF        NoRecFnd = True
     C                   EVAL      DBKEY  =  ISTT                               ************
     C                   EVAL      DBFILE =  'INTYP   '                         * DBERR 001*
     C                   EVAL      DBASE  =  001                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ITISPT = 4 or ITISPT = 6
     C                   EVAL      @@ERR = 0
     C                   ELSE
     C                   EVAL      @@ERR = 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** If end of file was encountered, report this fact
 
     C                   IF        EndOfFile = True
     C                   IF        FFTNBR = *BLANKS
     C                   EVAL      @ERRMS = 'MMM1006'
     C                   ELSE
     C                   EVAL      @ERRMS = 'MMM1002'
     C                   ENDIF
 
      ** Else, return the transaction number
 
     C                   ELSE
 
     C                   MOVE      TNBR          @TRRED
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - Read backwards through transaction amendments file
      *****************************************************************
 
     C     RDBCK         BEGSR
 
      ** Position to current record on file
 
     C     @@TNBR        SETLL     FFOTCCL0
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       EndOfFile = True or @@ERR = *ZERO
 
      ** Read previous from transaction file
 
     C                   READP     FFOTCCL0                               01
 
      ** If multi-branching, check if authorized to look at trade (based
      ** on branch) but if invalid continue searching for valid branch
 
     C                   IF        BJSBRC = *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   ENDIF
 
     C                   IF        EndOfFile = False and @@ERR = *ZERO
 
      ** Access INTYP to get instrument processing type
 
     C     ISTT          CHAIN     INTYP                              02
 
      ** If record not found
 
     C                   IF        NoRecFnd = True
     C                   EVAL      DBKEY  =  ISTT                               ************
     C                   EVAL      DBFILE =  'INTYP   '                         * DBERR 002*
     C                   EVAL      DBASE  =  002                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ITISPT = 4 or ITISPT = 6
     C                   EVAL      @@ERR = 0
     C                   ELSE
     C                   EVAL      @@ERR = 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** If start of file was encountered, report this fact
 
     C                   IF        EndOfFile = True
     C                   EVAL      @ERRMS = 'MMM1003'
 
      ** Else, return the transaction number.
 
     C                   ELSE
 
     C                   MOVE      TNBR          @TRRED
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for user authority if not multi-branching
      *****************************************************************
 
     C     CHAUTN        BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
 
      ** Return error message
 
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTRN - Validate transaction number
      *****************************************************************
 
     C     VALTRN        BEGSR
 
      ** Validate that the transaction number is numeric or blank.
 
     C                   TESTN                   FFTNBR               98
     C                   MOVE      FFTNBR        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     FFTNBR        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      FFTNBR        @@TNBR            6 0
 
      ** Return Error message
 
     C                   ELSE
     C                   EVAL      @ERRMS = 'APM0112'
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
 
     C     *INZSR        BEGSR
 
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** Transaction number
 
     C                   PARM                    FFTNBR            6
 
      ** Read forwards
      ** Read backwards
 
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
 
      ** Standing Data
      ** =============
 
     C                   PARM                    SDBANK
 
      ** Output Parameters
      ** =================
      ** Error Message
      ** Transaction number read
 
     C                   PARM                    @ERRMS            7
     C                   PARM                    @TRRED            6
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
